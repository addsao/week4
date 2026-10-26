//
//  PlaceDetailView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import CoreLocation

struct PlaceDetailView: View {
    let place: Place
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text(place.name)
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(
                    title: "Latitude",
                    value: String(format: "%.6f", place.coordinate.latitude)
                )
                DetailRow(
                    title: "Longitude",
                    value: String(format: "%.6f", place.coordinate.longitude)
                )
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Place Details")
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
