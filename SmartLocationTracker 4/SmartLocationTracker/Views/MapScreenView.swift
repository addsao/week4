//
//  MapScreenView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import MapKit

struct MapScreenView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Map")
                .font(.largeTitle.bold())
            
            MapView(
                locationManager: locationManager,
                places: locationManager.places
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}
