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
    private let manager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var previousLocation: CLLocation?
    @Published var isTracking = false
    @Published var lastUpdateTime: Date?
    
    // Tracking settings
    @Published var desiredAccuracy = kCLLocationAccuracyBest
    @Published var distanceFilter: CLLocationDistance = 10 // meters
    
    // Total distance traveled (meters)
    @Published var totalDistance: CLLocationDistance = 0
    @Published var lastDistance: CLLocationDistance = 0
    
    // Minimum distance to consider as movement (meters)
    private let minDistanceThreshold: CLLocationDistance = 5
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = desiredAccuracy
        manager.distanceFilter = distanceFilter
        manager.allowsBackgroundLocationUpdates = false
    }
    
    func startTracking() {
        // Check permission before starting
        guard manager.authorizationStatus == .authorizedWhenInUse ||
              manager.authorizationStatus == .authorizedAlways else {
            print("Location permission not granted.")
            return
        }
        manager.startUpdatingLocation()
        isTracking = true
        print("Started location tracking.")
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
        print("Stopped location tracking.")
    }
    
    func updateTrackingSettings(
        accuracy: CLLocationAccuracy,
        distance: CLLocationDistance
    ) {
        desiredAccuracy = accuracy
        distanceFilter = distance
        manager.desiredAccuracy = accuracy
        manager.distanceFilter = distance
    }
    
    func resetDistance() {
        totalDistance = 0
        lastDistance = 0
        previousLocation = nil
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        return from.distance(from: to) // meters
    }
    
    private func isValidLocation(_ location: CLLocation) -> Bool {
        // Ignore invalid or old location data
        if location.horizontalAccuracy < 0 {
            return false
        }
        
        // Ignore locations with poor accuracy
        if location.horizontalAccuracy > 100 { // 100 meters
            return false
        }
        
        // Ignore duplicated location (no movement)
        if let previous = previousLocation {
            let distance = location.distance(from: previous)
            if distance < 5 { // moved less than 5 meters
                return false
            }
        }
        
        return true
    }
    
    private func updateLocationInfo(_ location: CLLocation) {
        if !isValidLocation(location) {
            return
        }
        previousLocation = currentLocation
        currentLocation = location
        lastUpdateTime = Date()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let newLocation = locations.last else {
            print("No location data received.")
            return
        }
        
        if !isValidLocation(newLocation) {
            print("Ignored invalid location.")
            return
        }
        
        if let previous = previousLocation {
            let distance = calculateDistance(from: previous, to: newLocation)
            // Ignore very small movement
            if distance > minDistanceThreshold { // e.g. 5 meters
                lastDistance = distance
                totalDistance += distance
            }
        }
        
        previousLocation = newLocation
        updateLocationInfo(newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
