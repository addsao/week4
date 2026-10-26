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
            VStack(spacing: 16) {
                // Status indicator
                HStack {
                    Circle()
                        .fill(locationManager.isTracking ? Color.green : Color.gray)
                        .frame(width: 10, height: 10)
                    Text(locationManager.isTracking ? "Tracking Active" : "Not Tracking")
                }
                .font(.headline)
                
                // Location information
                VStack(alignment: .leading, spacing: 8) {
                    LocationInfoRow(
                        title: "Latitude",
                        value: locationManager.currentLocation?.coordinate.latitude != nil ? String(format: "%.4f°", locationManager.currentLocation!.coordinate.latitude) : "-"
                    )
                    LocationInfoRow(
                        title: "Longitude",
                        value: locationManager.currentLocation?.coordinate.longitude != nil ? String(format: "%.4f°", locationManager.currentLocation!.coordinate.longitude) : "-"
                    )
                    LocationInfoRow(
                        title: "Accuracy",
                        value: locationManager.currentLocation?.horizontalAccuracy != nil ? String(format: "±%.0f m", locationManager.currentLocation!.horizontalAccuracy) : "-"
                    )
                    LocationInfoRow(
                        title: "Last update",
                        value: locationManager.lastUpdateTime?.formatted(date: .omitted, time: .standard) ?? "-"
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Distance information
                HStack(spacing: 16) {
                    DistanceCard(
                        title: "Total Distance",
                        value: locationManager.totalDistance,
                        unit: "m",
                        icon: "figure.walk",
                        color: .blue
                    )
                    DistanceCard(
                        title: "Last Movement",
                        value: locationManager.lastDistance,
                        unit: "m",
                        icon: "arrow.right",
                        color: .green
                    )
                }
                
                Spacer()
                
                // Start/Stop buttons
                HStack(spacing: 12) {
                    if locationManager.isTracking {
                        Button(action: {
                            locationManager.stopTracking()
                        }) {
                            Label("Stop Tracking", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    } else {
                        Button(action: {
                            locationManager.startTracking()
                        }) {
                            Label("Start Tracking", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .navigationTitle("Smart Location")
        }
    }
}

// Subview hỗ trợ hiển thị từng hàng thông tin toạ độ
struct LocationInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

// Subview hỗ trợ hiển thị thẻ quãng đường (DistanceCard)
struct DistanceCard: View {
    let title: String
    let value: Double
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(String(format: "%.1f %@", value, unit))
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
