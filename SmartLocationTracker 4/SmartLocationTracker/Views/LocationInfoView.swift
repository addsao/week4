//
//  LocationInfoView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .fontWeight(.medium)
                    .foregroundColor(valueColor)
            }
            .padding(.vertical, 4)
            Divider()
        }
    }
}

struct LocationInfoView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            InfoRow(
                title: "Latitude",
                value: String(format: "%.4f", locationManager.latitude)
            )
            InfoRow(
                title: "Longitude",
                value: String(format: "%.4f", locationManager.longitude)
            )
            InfoRow(
                title: "Accuracy",
                value: String(format: "%.1f m", locationManager.accuracy)
            )
            InfoRow(
                title: "Permission",
                value: locationManager.authorizationStatusText,
                valueColor: locationManager.isAuthorized ? .green : .red
            )
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
        .shadow(radius: 3)
    }
}
