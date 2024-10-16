//
//  HomeViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/16/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    
    init() {
        fetchDrivers()
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.map({ try? $0.data(as: User.self) })
                print("Drivers: \(drivers)")
            }
    }
}
