//
//  SideMenuView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
            VStack(spacing: 40) {
                // header view
                VStack(alignment: .leading, spacing: 32) {
                    // user info
                    HStack {
                        Image("male-profile-photo")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Damien B")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("test@email.com")
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                        }
                    }
                    
                    // become a driver option
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Do more with your account")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "dollarsign.square")
                                .font(.title2)
                                .imageScale(.medium)
                            
                            Text("make money driving")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(6)
                        }
                    }
                    
                    Rectangle()
                        .frame(width: 296, height: 0.75)
                        .opacity(0.7)
                        .foregroundStyle(Color(.separator))
                        .shadow(color: .black.opacity(0.7), radius: 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                
                // menu option list
                VStack {
                    ForEach(SideMenuOptionViewModel.allCases) { menuOption in
                        NavigationLink(value: menuOption) {
                            SideMenuOptionView(viewModel: menuOption)
                                .padding()
                        }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) { menuOption in
                    Text(menuOption.title)
                }
                
                Spacer()
                
            }
            .padding(.top, 32)
    }
}

#Preview {
    SideMenuView()
}
