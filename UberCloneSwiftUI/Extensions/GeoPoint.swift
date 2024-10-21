//
//  GeoPoint.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/21/24.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
