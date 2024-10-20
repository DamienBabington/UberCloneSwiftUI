//
//  Trip.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/19/24.
//

import Foundation
import Firebase

struct Trip: Identifiable, Codable {
    let id: String
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let passengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let pickupLocationAddress: String
    let dropoffLocationName: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
}
