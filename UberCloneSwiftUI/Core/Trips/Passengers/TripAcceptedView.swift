//
//  TripAcceptedView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/21/24.
//

import SwiftUI

struct TripAcceptedView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 10)
            
            if let trip = viewModel.trip {
                // pickup info view
                VStack {
                    HStack {
                        Text("Meet your driver at \(trip.pickupLocationName) for your trip to \(trip.dropoffLocationName)")
                            .font(.body)
                            .frame(height: 44)
                            .lineLimit(2)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(trip.travelTimeToPassenger)")
                                .bold()
                            
                            Text("min")
                                .bold()
                        }
                        .frame(minWidth: 56, minHeight: 56)
                        .foregroundStyle(.white)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                // driver info view
                VStack {
                    HStack {
                        Image("male-profile-photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.driverName)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(Color(.systemYellow))
                                    .imageScale(.small)
                                
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        // driver vehicle info
                        VStack(alignment: .center, spacing: 8) {
                            Image("uber-x")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 64)
                            
                            HStack {
                                Text("Merceded S -")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.gray)
                                
                                Text("5G4K08")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(width: 160)
                            .padding(.bottom)
                        }
                    }
                    
                    Divider()
                }
                .padding()
            }
            
            Button {
                print("Cancel Trip")
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundStyle(.white)
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripAcceptedView()
}
