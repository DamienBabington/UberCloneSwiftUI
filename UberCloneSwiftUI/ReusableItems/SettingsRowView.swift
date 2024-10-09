//
//  SettingsRowView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundStyle(tintColor)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(Color.theme.primaryTextColor)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "bell.circle.fill", title: "Notifications", tintColor: Color(.systemPurple))
}
