//
//  SettingsView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SettingsView: View {
    private let user: User
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            List {
                // User info header section
                Section {
                    HStack {
                        Image("male-profile-photo")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .padding(4)
                }
                
                // Favorites section
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(locationCategory: viewModel)
                        } label: {
                            SavedLocationRowView(viewModel: viewModel, user: user)
                        }
                    }
                }
                
                // Settings section
                Section("Settings") {
                    SettingsRowView(imageName: "bell.circle.fill",
                                    title: "Notifications",
                                    tintColor: Color(.systemPurple))
                    
                    SettingsRowView(imageName: "creditcard.circle.fill",
                                    title: "Payment Methods",
                                    tintColor: Color(.systemBlue))
                }
                      
                // Account section
                Section("Account") {
                    SettingsRowView(imageName: "dollarsign.circle.fill",
                                    title: "Make money driving",
                                    tintColor: Color(.systemGreen))
                    
                    SettingsRowView(imageName: "arrow.left.circle.fill",
                                    title: "Signout",
                                    tintColor: Color(.systemRed))
                    .onTapGesture {
                        authViewModel.signout()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SettingsView(user: User(uid: "12345", fullName: "John Doe", email: "johndoe@gmail.com"))
    }
}
