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


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            self.servicesEnabled = CLLocationManager.locationServicesEnabled()
        }
    }
}


class LocationManager: NSObject, ObservableObject {
    // CLLocationManager instance
    private let manager = CLLocationManager()
    
    // Published properties to update the UI
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var servicesEnabled: Bool
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        servicesEnabled = CLLocationManager.locationServicesEnabled()
        super.init()
        manager.delegate = self
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func refreshStatus() {
        servicesEnabled = CLLocationManager.locationServicesEnabled()
        authorizationStatus = manager.authorizationStatus
    }
}
