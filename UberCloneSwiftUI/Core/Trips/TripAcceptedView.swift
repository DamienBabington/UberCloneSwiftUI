//
//  TripAcceptedView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/21/24.
//

import SwiftUI

struct TripAcceptedView: View {
    var body: some View {
        VStack {
            Text("Your driver is on the way")
                .padding()
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripAcceptedView()
}
