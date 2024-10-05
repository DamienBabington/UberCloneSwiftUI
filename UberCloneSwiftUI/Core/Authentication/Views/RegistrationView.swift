//
//  RegistrationView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/5/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack() {
                // image and title
                VStack(spacing: -16) {
                    Image("uber-app-icon")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("UBER")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
                
                // input fields
                VStack(spacing: 32) {
                    // input field 1
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email Address")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)
                        
                        TextField(text: $email) {
                            Text(verbatim: "name@example.com")
                                .foregroundStyle(.white)
                        }

                        Rectangle()
                            .foregroundStyle(Color(.init(white: 1, alpha: 0.5)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                    
                    // input field 2
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Password")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)
                        
                        TextField(text: $email) {
                            Text("Enter your password")
                                .foregroundStyle(.white)
                        }

                        Rectangle()
                            .foregroundStyle(Color(.init(white: 1, alpha: 0.5)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // social sign-in view
                VStack {
                    HStack(spacing: 24) {
                        Rectangle()
                            .frame(width: 76, height: 1)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                        
                        Text("Sign in with social")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        Rectangle()
                            .frame(width: 76, height: 1)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                    }
                    
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Image("facebook-sign-in-icon")
                                .resizable()
                                .frame(width: 44, height: 44)
                        }
                        
                        Button {
                            
                        } label: {
                            Image("google-sign-in-icon")
                                .resizable()
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                .padding(.vertical)
                
                // sign-in button
                Button {
                    
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .foregroundStyle(.black)
                        
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                .background(Color(.white))
                .cornerRadius(10)
                .padding(.vertical)

                // signup button
                Button {
                    
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                        
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                }

            }
        }
    }
}

#Preview {
    RegistrationView()
}
