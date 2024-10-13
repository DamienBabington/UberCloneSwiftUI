//
//  SavedLocationSearchView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SavedLocationSearchView: View {
    @State private var text: String = ""
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                .imageScale(.medium)
                .padding(.leading)
                
                TextField("Search for a location", text: $locationViewModel.queryFragment)
                    .frame(height: 32)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                    .padding(.trailing)
            }
            .padding(.top)
            
            Spacer()
            
            LocationSearchResultsView(locationViewModel: locationViewModel, config: .saveLocation)
        }
        .navigationTitle("Add Home")
    }
}

#Preview {
    NavigationStack {
        SavedLocationSearchView()
    }
}
