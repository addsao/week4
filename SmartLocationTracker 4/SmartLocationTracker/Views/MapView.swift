//
//  MapView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager: LocationManager
    var places: [Place]
    
    var body: some View {
        Map {
            UserAnnotation()
            
            ForEach(places) { place in
                Marker(place.name, coordinate: place.coordinate)
                    .tint(.red)
            }
        }
        .mapStyle(.standard)
    }
}
