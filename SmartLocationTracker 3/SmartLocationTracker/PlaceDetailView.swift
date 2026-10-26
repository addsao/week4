//
//  PlaceDetailView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI

struct PlaceDetailView: View {
    let place: Place
    let distanceText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(place.name)
                    .font(.title2)
                    .bold()
                Spacer()
                Text(distanceText)
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            
            if let address = place.address {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label(String(format: "%.4f", place.latitude), systemImage: "location")
                Label(String(format: "%.4f", place.longitude), systemImage: "location")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
    }
}
