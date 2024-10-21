//
//  UberMapViewRepresentable.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/11/24.
//

/* UIViewRepresentable protocol allows creation of a view 
    with UIKit that can be represented in SwiftUI.
 */

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    
    /* Don't update VM properties in this class or else it will cause a retain cycle since the VM is being observed.
        Instead, use the LocationManager to update the VM's userLocation property in the HomeView
     */
    
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearAndRecenterMapView()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(with: coordinate)
            }
            break
        case .mapUpdated:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}


extension UberMapViewRepresentable {
    
    // This coordinator class allows use of UIKit's MapKit functionality by acting as the map view's delegate
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Coordinator Properties
        
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate Method
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .blue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(named: "chevron-sign-to-right")
                return view
            }
            return nil
        }
        
        // MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyline(with destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .mapUpdated
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }        
        
        func clearAndRecenterMapView() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            // recenter map view
            if let currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0) })
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
