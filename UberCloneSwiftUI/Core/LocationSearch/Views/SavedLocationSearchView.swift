//
//  SavedLocationSearchView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/9/24.
//

import SwiftUI

struct SavedLocationSearchView: View {
    @State private var text: String = ""
    @ObservedObject var homeviewModel: HomeViewModel
    let locationCategory: SavedLocationViewModel
    
    var body: some View {
        VStack {
            TextField("Search for a location", text: $homeviewModel.queryFragment)
                .frame(height: 32)
                .padding(.leading)
                .background(Color(.systemGray5))
                .padding()
            
            Spacer()
            
            LocationSearchResultsView(viewModel: homeviewModel, config: .saveLocation(locationCategory))
        }
        .navigationTitle(locationCategory.subtitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
    }
}

//#Preview {
//    NavigationStack {
//        SavedLocationSearchView(locationCategory: .home)
//    }
//}
