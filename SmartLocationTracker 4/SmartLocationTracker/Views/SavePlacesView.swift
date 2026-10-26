//
//  SavePlacesView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import CoreLocation

struct SavedPlacesView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.places) { place in
                    NavigationLink {
                        PlaceDetailView(place: place)
                    } label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .font(.headline)
                                Text("\(place.coordinate.latitude), \(place.coordinate.longitude)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: locationManager.deletePlace)
            }
            .navigationTitle("Saved Places")
            .toolbar {
                EditButton()
            }
        }
    }
}
