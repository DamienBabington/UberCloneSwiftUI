//
//  HomeView.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Group {
            // check if user is logged in
            if authViewModel.userSession == nil {
                LoginView()
            } else if let user = authViewModel.currentUser {
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView(user: user)
                        }
                        mapView
                            .offset(x: showSideMenu ? 316 : 0)
                            .shadow(color: showSideMenu ? .black : .clear, radius: 10)
                    }
                }
                .navigationViewStyle(.stack)
            }
        }
    }
}


extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView()
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if mapState == .locationSelected || mapState == .mapUpdated {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            // this modifier allows us to implement functionality when this observed property is updated
            if let location {
                locationViewModel.userLocation = location
            }
        }
        .onReceive(locationViewModel.$selectedUberLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationSearchViewModel())
        .environmentObject(AuthViewModel())
}
