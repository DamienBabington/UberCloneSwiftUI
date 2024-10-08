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
    
    func registerUser(withEmail email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to sign in with error: \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
        }
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to sign up with error: \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch let error {
            print("Failed to sign out with error: \(error.localizedDescription)")
        }
    }
}
