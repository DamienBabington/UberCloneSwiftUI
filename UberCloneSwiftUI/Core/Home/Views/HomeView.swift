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
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
            
            if let user = authViewModel.currentUser {
                if user.accountType == .passenger {
                    if mapState == .locationSelected || mapState == .polylineAdded {
                        RideRequestView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .tripRequested {
                        TripLoadingView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .tripAccepted {
                        TripAcceptedView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .tripRejected {
                        // show trip rejected view
                    }
                } else {
                    if let trip = homeViewModel.trip {
                        if mapState == .tripRequested {
                            AcceptTripView(trip: trip)
                                .transition(.move(edge: .bottom))
                        } else if mapState == .tripAccepted {
                            PickUpPassengerView(trip: trip)
                                .transition(.move(edge: .bottom))
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            // this modifier allows us to implement functionality when this observed property is updated
            if let location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip else { return }
            
            withAnimation(.spring()) {
                switch trip.tripState {
                case .requested:
                    self.mapState = .tripRequested
                case .rejected:
                    self.mapState = .tripRejected
                case.accepted:
                    self.mapState = .tripAccepted
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
