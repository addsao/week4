//
//  LocationManager.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var errorMessage: String?
    private var completionHandler: ((CLLocation?) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10 // in meters
    }

    func requestCurrentLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location permission not granted.")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func requestCurrentLocation(
        completion: ((CLLocation?) -> Void)? = nil
    ) {
        if manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
            self.completionHandler = completion
        } else {
            completion?(nil)
        }
    }

    func startUpdatingLocation() {
        guard manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways else {
            print("Location permission not granted.")
            return
        }
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            print("No location received")
            return
        }
        
        let coordinate = location.coordinate
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let accuracy = location.horizontalAccuracy
        let altitude = location.altitude
        let timestamp = location.timestamp
        
        print("Lat: \(latitude)")
        print("Lng: \(longitude)")
        print("Accuracy: \(accuracy) m")
        print("Time: \(timestamp)")
        
        // Update the published property
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        print("Failed to get location: \(error)")
        DispatchQueue.main.async {
            self.currentLocation = nil
            self.errorMessage = self.errorMessage(from: error)
        }
    }

    private func errorMessage(from error: Error) -> String {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied: return "Location permission denied."
            case .locationUnknown: return "Location unknown."
            case .network: return "Network error."
            default: return "Failed to get location: \(error.localizedDescription)"
            }
        } else {
            return "Failed to get location: \(error.localizedDescription)"
        }
    }
}
