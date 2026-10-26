//
//  HomeView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Smart Location Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            LocationInfoView(locationManager: locationManager)
            
            HStack(spacing: 16) {
                Button(action: {
                    locationManager.startUpdatingLocation()
                }) {
                    Label("Start Tracking", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    locationManager.stopUpdatingLocation()
                }) {
                    Label("Stop Tracking", systemImage: "stop.fill")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
