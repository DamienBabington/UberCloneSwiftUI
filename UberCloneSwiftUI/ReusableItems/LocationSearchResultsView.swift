//
//  LocationSearchResultsView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/12/24.
//

import SwiftUI

struct LocationSearchResultsView: View {
    @StateObject var locationViewModel: LocationSearchViewModel
    let config: LocationResultsViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(locationViewModel.results, id: \.self) { result in
                    LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring) {
                                locationViewModel.selectLocation(result, config: config)
                            }
                        }
                }
            }
        }
    }
}
