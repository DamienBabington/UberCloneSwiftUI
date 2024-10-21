//
//  DeveloperPreview.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/15/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockTrip = Trip(
        id: NSUUID().uuidString,
        passengerUid: NSUUID().uuidString,
        driverUid: NSUUID().uuidString,
        passengerName: "Mock Passenger",
        driverName: "Mock Driver",
        passengerLocation: .init(latitude: 37.123, longitude: -122.1),
        driverLocation: .init(latitude: 37.125, longitude: -122.1),
        pickupLocationName: "Apple Campus",
        pickupLocationAddress: "123 Main St, Palo Alto, CA",
        dropoffLocationName: "Starbucks",
        pickupLocation: .init(latitude: 37.456, longitude: -122.15),
        dropoffLocation: .init(latitude: 37.042, longitude: -122.2),
        tripCost: 47.0
    )
    
    let mockUser = User(
        uid: NSUUID().uuidString,
        fullName: "Dame Bab",
        email: "dame@example.com", 
        coordinates: GeoPoint(latitude: 37.38, longitude: -122.05),
        accountType: .passenger,
        homeLocation: nil,
        workLocation: nil
    )
}
