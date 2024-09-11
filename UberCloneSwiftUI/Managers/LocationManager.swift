//
//  LocationManager.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/11/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
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
        guard !locations.isEmpty else { return }
        /* Stop updating location because we only need to get the current location in this file once 
            when the map is first loaded, then we can handle the rest of the map updates in the map view.
         */
        locationManager.stopUpdatingLocation()
    }
}

