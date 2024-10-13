//
//  LocationSearchView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/12/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            // header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .padding(.leading, 8)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to?", text: $locationViewModel.queryFragment)
                        .frame(height: 32)
                        .padding(.leading, 8)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // list view
            LocationSearchResultsView(locationViewModel: locationViewModel, config: .ride)
        }
        .background(Color.theme.backgroundColor)
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(LocationSearchViewModel())
}
