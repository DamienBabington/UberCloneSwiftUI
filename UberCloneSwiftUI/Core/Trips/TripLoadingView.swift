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
            Text("Finding you a ride..")
                .padding()
            
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripLoadingView()
}
