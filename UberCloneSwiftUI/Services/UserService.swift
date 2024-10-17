//
//  UserService.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/17/24.
//

import FirebaseAuth
import FirebaseFirestore

class UserService: ObservableObject {
    
    static let shared = UserService()
    @Published var user: User?
    
    init() {
        print("Did init user service")
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            print("Did fetch user from Firestore")
            
            if let error {
                print("Failed to fetch user data with error: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.user = user
        }
    }
}
