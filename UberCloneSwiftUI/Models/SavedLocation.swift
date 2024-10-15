//
//  SavedLocation.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/13/24.
//

import Foundation
import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
