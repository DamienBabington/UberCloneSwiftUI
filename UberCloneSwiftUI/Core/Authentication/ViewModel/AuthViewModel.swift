//
//  AuthViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to sign in with error: \(error.localizedDescription)")
                return
            }
            
            guard let firebaseUser = result?.user else { return }
            self.userSession = result?.user
            
            // encode user data and save to Firestore
            let user = User(uid: firebaseUser.uid, fullName: fullName, email: email)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
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
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        // get current user's data from Firestore
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error {
                print("Failed to fetch user data with error: \(error.localizedDescription)")
                return
            }
            guard let snapshot else { return }
            
            // decode snapshot data to our User data type
            guard let user = try? snapshot.data(as: User.self) else { return }
        }
    }
}
