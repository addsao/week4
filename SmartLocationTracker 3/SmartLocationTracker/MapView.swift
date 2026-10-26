//
//  MapView.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    let places: [Place] = samplePlaces
    
    @State private var selectedPlace: Place?
    @State private var showPlaceDetail = false
    @State private var distanceText: String = "--"
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition, selection: $selectedPlace) {
                // Hiển thị vị trí người dùng
                UserAnnotation()
                
                // Hiển thị các Marker địa điểm
                ForEach(places) { place in
                    Marker(place.name, coordinate: place.coordinate)
                        .tint(.red)
                        .tag(place)
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .navigationTitle("Saved Places")
            .sheet(isPresented: $showPlaceDetail) {
                if let place = selectedPlace {
                    PlaceDetailView(place: place, distanceText: distanceText)
                        .presentationDetents([.fraction(0.3)])
                }
            }
            .onChange(of: selectedPlace) { place in
                if let place = place {
                    updateDistance(to: place)
                    showPlaceDetail = true
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: place.coordinate,
                            latitudinalMeters: 1000,
                            longitudinalMeters: 1000
                        )
                    )
                }
            }
            .onAppear {
                locationManager.startTracking()
            }
        }
    }

    private func updateDistance(to place: Place) {
        if let userLocation = locationManager.currentLocation {
            let placeLocation = CLLocation(
                latitude: place.latitude,
                longitude: place.longitude
            )
            let distanceInMeters = userLocation.distance(from: placeLocation)
            let distanceInKilometers = distanceInMeters / 1000.0
            self.distanceText = String(format: "%.2f km", distanceInKilometers)
        } else {
            self.distanceText = "--"
        }
    }
}

#Preview {
    MapView()
}
