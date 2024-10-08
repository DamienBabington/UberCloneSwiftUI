//
//  MapViewActionButton.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/12/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title3)
                .foregroundStyle(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            break
//            authViewModel.signout()
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .mapUpdated:
            mapState = .noInput
            locationViewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .mapUpdated:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
