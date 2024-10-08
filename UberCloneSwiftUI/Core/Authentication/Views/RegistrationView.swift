//
//  RegistrationView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                                
                VStack {
                    // input fields
                    VStack(spacing: 56) {
                        CustomInputField(text: $fullName,
                                         title: "Full Name",
                                         placeholder: "Enter your name")
                        
                        CustomInputField(text: $email,
                                         title: "Email Address",
                                         placeholder: "name@example.com")
                        
                        CustomInputField(text: $password,
                                         title: "Create Password",
                                         placeholder: "Enter your password",
                                         isSecureField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    // signup button
                    Button {
                        viewModel.registerUser(withEmail: email, password: password, fullName: fullName)
                    } label: {
                        HStack {
                            Text("SIGN UP")
                                .foregroundStyle(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }                    
                    .background(Color(.white))
                    .cornerRadius(10)
                    .padding(.vertical)
                    
                    Spacer()
                }
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    RegistrationView()
}
