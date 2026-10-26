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
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 65))
                    .foregroundColor(.blue)
                
                Text("Location Services")
                    .font(.title2.bold())
                
                Group {
                    statusRow(title: "Service Enabled",
                              value: locationManager.servicesEnabled ? "Yes" : "No")
                    statusRow(title: "Permission",
                              value: permissionText)
                }
                
                Button("Request Location Permission") {
                    locationManager.requestPermission()
                }
                .buttonStyle(.borderedProminent)
                .disabled(locationManager.authorizationStatus != .notDetermined)
                
                Button("Refresh Status") {
                    locationManager.refreshStatus()
                }
                .buttonStyle(.bordered)
                
            }
            .padding()
            .navigationTitle("Smart Location")
            .onAppear {
                locationManager.refreshStatus()
            }
        }
    }
    
    // MARK: - Helper Views (Đã chuyển vào trong struct)
    @ViewBuilder
    private func statusRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private var permissionText: String {
        switch locationManager.authorizationStatus {
        case .notDetermined: return "NotDetermined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedWhenInUse: return "AuthorizedWhenInUse"
        case .authorizedAlways: return "AuthorizedAlways"
        @unknown default : return "Unknown" 
        }
    }
}

#Preview {
    ContentView()
}
