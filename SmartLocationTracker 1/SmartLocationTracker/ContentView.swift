//
//  ContentView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                if let location = locationManager.currentLocation {
                    // Show location information (same as previous slide)
                    LocationInfoView(location: location)
                } else if let error = locationManager.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text("Unable to get your location")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ProgressView("Requesting location...")
                }
            }
            
            Button("Get Current Location") {
                locationManager.requestCurrentLocation()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct LocationInfoView: View {
    let location: CLLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Latitude: \(location.coordinate.latitude)")
            Text("Longitude: \(location.coordinate.longitude)")
            Text("Altitude: \(location.altitude) m")
            Text("Accuracy: ± \(location.horizontalAccuracy) m")
            Text("Time: \(location.timestamp)")
        }
    }
}

#Preview {
    ContentView()
}
