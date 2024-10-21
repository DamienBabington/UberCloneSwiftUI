//
//  TripLoadingView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/21/24.
//

import SwiftUI

struct TripLoadingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 10)
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Connecting you to a driver")
                        .font(.headline)
                    
                    Text("Arriving at 1:30pm")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.systemBlue))
                }
                .padding()
                
                Spacer()
                
                Spinner(lineWidth: 6, height: 48, width: 48)
                    .padding(.vertical)
                    .padding(.leading)
                    .padding(.trailing, 36)
            }
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripLoadingView()
}
