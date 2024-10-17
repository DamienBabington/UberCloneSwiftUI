//
//  AuthViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String) {
        guard let location = LocationManager.shared.userLocation else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to sign in with error: \(error.localizedDescription)")
                return
            }
            
            guard let firebaseUser = result?.user else { return }
            self.userSession = result?.user
            
            // encode user data and save to Firestore
            let user = User(
                uid: firebaseUser.uid,
                fullName: fullName,
                email: email,
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .passenger
            )
            
            self.currentUser = user
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
            self.fetchUser()
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
        service.$user
            .sink { user in
                self.currentUser = user
            }
            .store(in: &cancellables)
    }
}
