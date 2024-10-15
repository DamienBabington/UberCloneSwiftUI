//
//  SavedLocationRowView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SavedLocationRowView: View {
    let viewModel: SavedLocationViewModel
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundStyle(Color(.systemBlue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.theme.primaryTextColor)
                
                Text(viewModel.subtitle(forUser: user))
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
    }
}

//#Preview {
//    SavedLocationRowView(viewModel: .home)
//}
