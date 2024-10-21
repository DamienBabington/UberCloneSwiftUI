//
//  UberLocation.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/26/24.
//

import CoreLocation

struct UberLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
