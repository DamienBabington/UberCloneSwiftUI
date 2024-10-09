//
//  SavedLocationRowView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SavedLocationRowView: View {
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundStyle(Color(.systemBlue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.theme.primaryTextColor)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    SavedLocationRowView(imageName: "house.circle.fill", title: "Home", subtitle: "Add Home")
}
