//
//  LocationManager.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/11/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        /* Stop updating location because we only need to get the current location in this file once
            when the map is first loaded, then we can handle the rest of the map updates in the map view.
         */
        locationManager.stopUpdatingLocation()
    }
}

