//
//  LocationSearchActivationView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/12/24.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundStyle(.gray)
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(Rectangle()
            .fill(.white)
            .shadow(color: .black, radius: 6))
    }
}

#Preview {
    LocationSearchActivationView()
}
