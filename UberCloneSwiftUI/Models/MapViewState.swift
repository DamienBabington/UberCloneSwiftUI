//
//  MapViewState.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/23/24.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripAccepted
    case tripRejected
    case tripCancelledByPassenger
    case tripCancelledByDriver
}
