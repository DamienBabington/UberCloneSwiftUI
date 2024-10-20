//
//  AcceptTripView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/19/24.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
    
    @State private var region: MKCoordinateRegion
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        self.region = MKCoordinateRegion(center: center, span: span)
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 10)
            
            // pickup confirmation
            VStack {
                HStack {
                    Text("Would you like to pick up this passenger?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 44)
                    
                    Spacer()
                    
                    VStack {
                        Text("$10")
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
                        Text("FULL NAME")
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
                        
                        Text("$22.04")
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                
                Divider()
            }
            .padding()
            
            // pickup location
            VStack {
                HStack {
                    // address info
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Apple campus")
                            .font(.headline)
                        
                        Text("Infinite Loop 1, Santa Clara County")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    // distance
                    VStack {
                        Text("5.2")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("mi")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                // map
                Map(coordinateRegion: $region)
                    .frame(height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.6), radius: 10)
                    .padding()
                
                Divider()
                    .padding(.horizontal)
            }
            
            // action buttons
            HStack {
                Button {
                    
                } label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemRed))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Accept")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
    }
}

#Preview {
    AcceptTripView()
}