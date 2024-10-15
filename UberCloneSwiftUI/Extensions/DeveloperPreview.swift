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
