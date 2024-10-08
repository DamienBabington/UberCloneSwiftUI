//
//  AuthViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        userSession = Auth.auth().currentUser
    }
}
