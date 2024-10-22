//
//  PickUpPassengerView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/22/24.
//

import SwiftUI

struct PickUpPassengerView: View {
    
    let trip: Trip
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 10)
            
            // pickup confirmation
            VStack {
                HStack {
                    Text("Pick up \(trip.passengerName) at \(trip.dropoffLocationName)")
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 44)
                    
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
            
            // user info
            VStack {
                HStack {
                    Image("male-profile-photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.passengerName)
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
                    
                    VStack(spacing: 6) {
                        Text("Earnings")
                        
                        Text("\(trip.tripCost.toCurrency())")
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                
                Divider()
            }
            .padding()
            
            Button {
                viewModel.cancelTripAsDriver()
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

struct PickUpPassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PickUpPassengerView(trip: dev.mockTrip)
    }
}

