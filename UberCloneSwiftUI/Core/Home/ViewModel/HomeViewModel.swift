//
//  HomeViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var drivers = [User]()
    @Published var trip: Trip?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    var currentUser: User?
    var routeToPickupLocation: MKRoute?
    var authViewModel: AuthViewModel?
    
    // location search properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropoffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        self.fetchDrivers()
    }
    
    // MARK: - Helpers
    
    var tripCancelledMessage: String {
        guard let user = currentUser, let trip else { return "" }
        
        if user.accountType == .passenger {
            if trip.state == .driverCancelled {
                return "Your driver cancelled this trip."
            } else if trip.state == .passengerCancelled {
                return "Your trip has been cancelled."
            }
        } else {
            if trip.state == .driverCancelled {
                return "Your trip has been cancelled."
            } else if trip.state == .passengerCancelled {
                return "The trip has been cancelled by the passenger."
            }
        }
        
        return ""
    }
    
    func viewForState(_ state: MapViewState, user: User) -> some View {
        switch state {
        case .polylineAdded, .locationSelected:
            return AnyView(RideRequestView())
        case .tripRequested:
            if user.accountType == .passenger {
                return AnyView(TripLoadingView())
            } else {
                if let trip = self.trip {
                    return AnyView(AcceptTripView(trip: trip))
                }
            }
        case .tripAccepted:
            if user.accountType == .passenger {
                return AnyView(TripAcceptedView())
            } else {
                if let trip = self.trip {
                    return AnyView(PickUpPassengerView(trip: trip))
                }
            }
        case .tripCancelledByPassenger, .tripCancelledByDriver:
            return AnyView(TripCancelledView())
        default:
            break
        }
        
        return AnyView(Text(""))
    }
    
    // MARK: - User API
    
    func fetchUsers() {
        service.$user
            .sink { user in
                self.currentUser = user
                guard let user else { return }

                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()
                } else {
                    self.addTripObserverForDriver()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTripState(state: TripState) {
        guard let trip else { return }
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToPassenger"] = trip.travelTimeToPassenger
        }
        
        Firestore.firestore().collection("trips").document(trip.id).updateData(data) { _ in
            print("Did update trip with state: \(state)")
        }
    }
    
    func deleteTrip() {
        guard let trip else { return }
        Firestore.firestore().collection("trips").document(trip.id).delete { _ in
            self.trip = nil
        }
    }
}

// MARK: - Passenger API

extension HomeViewModel {
    
    func addTripObserverForPassenger() {
        guard let currentUser, currentUser.accountType == .passenger else { return }
        Firestore.firestore().collection("trips")
            .whereField("passengerUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                
                print("Updated trip state: \(trip.state)")
        }
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.compactMap({ try? $0.data(as: User.self) })
                self.drivers = drivers
            }
    }
    
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser else { return }
        guard let dropoffLocation = selectedUberLocation else { return }
        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        
        getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark else { return }
            
            let tripCost = self.computeRidePrice(for: .uberX)
            
            let trip = Trip(
                passengerUid: currentUser.uid,
                driverUid: driver.uid,
                passengerName: currentUser.fullName,
                driverName: driver.fullName,
                passengerLocation: currentUser.coordinates,
                driverLocation: driver.coordinates,
                pickupLocationName: placemark.name ?? "Current Location",
                pickupLocationAddress: self.addressFromPlacemark(placemark),
                dropoffLocationName: dropoffLocation.title,
                pickupLocation: currentUser.coordinates,
                dropoffLocation: dropoffGeoPoint,
                tripCost: tripCost,
                distanceToPassenger: 0,
                travelTimeToPassenger: 0,
                state: .requested
            )
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("Did upload trip to Firestore")
            }
        }
    }
    
    func cancelTripAsPassenger() {
        updateTripState(state: .passengerCancelled)
    }
}

// MARK: - Driver API

extension HomeViewModel {
    
    func addTripObserverForDriver() {
        guard let currentUser, currentUser.accountType == .driver else { return }
        Firestore.firestore().collection("trips")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                
                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(),
                                         to: trip.pickupLocation.toCoordinate()) { route in
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassenger = (Int(route.expectedTravelTime / 60))
                    self.trip?.distanceToPassenger = route.distance
                }
        }
    }
    
    func rejectTrip() {
        updateTripState(state: .rejected)
    }
    
    func acceptTrip() {
        updateTripState(state: .accepted)
    }
    
    func cancelTripAsDriver() {
        updateTripState(state: .driverCancelled)
    }
}

// MARK: - Location Search Helpers

extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            result += " \(subThoroughfare)"
        }
        
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subAdministrativeArea)"
        }
        
        return result
    }
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig, completion: @escaping () -> ()) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error {
                print("location search failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let savedLocation = SavedLocation(title: localSearch.title,
                                                  address: localSearch.subtitle,
                                                  coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
                if viewModel.databaseKey == "homeLocation" {
                    self.authViewModel?.currentUser?.homeLocation = savedLocation
                } else {
                    self.authViewModel?.currentUser?.workLocation = savedLocation
                }
            }
            completion()
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        /* Returns a location object based on a query containing the selected location's name
            and address (title & subtitle). This is necessary to access the location's
            coordinates rather than just the address.
         */
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(for rideType: RideType) -> Double {
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let start = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        
        let tripDistanceInMeters = start.distance(from: destination)
        return rideType.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping(MKRoute) -> Void) {
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error {
                print("Failed to get directions with error: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropoffTime = formatter.string(from: Date() + expectedTravelTime)
    }
    
}

// MARK: - MKLocalSearchCompleterDelegate

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
 
