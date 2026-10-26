//
//  LocationManager.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var accuracy: Double = 0.0
    @Published var isTracking: Bool = false
    @Published var places: [Place] = [
        Place(name: "HCMUTE", latitude: 10.8506, longitude: 106.7719, address: "Ho Chi Minh City University of Technology and Education"),
        Place(name: "Ben Thanh Market", latitude: 10.7725, longitude: 106.6997, address: "District 1, Ho Chi Minh City"),
        Place(name: "Suoi Tien Park", latitude: 10.8731, longitude: 106.8185, address: "Thu Duc City, Ho Chi Minh City"),
        Place(name: "Diamond Island", latitude: 10.7769, longitude: 106.7494, address: "Thu Duc City, Ho Chi Minh City")
    ]
    
    private let locationManager = CLLocationManager()
    
    var latitude: Double {
        currentLocation?.coordinate.latitude ?? 0.0
    }
    
    var longitude: Double {
        currentLocation?.coordinate.longitude ?? 0.0
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    var authorizationStatusText: String {
        switch authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedWhenInUse, .authorizedAlways: return "Authorized"
        @unknown default: return "Unknown"
        }
    }
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        guard isAuthorized else {
            requestPermission()
            return
        }
        locationManager.startUpdatingLocation()
        isTracking = true
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        isTracking = false
    }
    
    func deletePlace(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            self.accuracy = location.horizontalAccuracy
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
