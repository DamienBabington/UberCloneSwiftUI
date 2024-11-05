//
//  LocationSearchResultsView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/12/24.
//

import SwiftUI

struct LocationSearchResultsView: View {
    @StateObject var viewModel: HomeViewModel
    let config: LocationResultsViewConfig
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.selectLocation(result, config: config) {
                                    self.dismiss()
                                }
                            }
                        }
                }
            }
        }
    }
}
