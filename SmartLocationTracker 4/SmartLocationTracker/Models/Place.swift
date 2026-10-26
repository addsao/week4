//
//  Placwe.swift
//  SmartLocationTracker
//
//  Created by MAY 02 on 26/10/26.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Codable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        address: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}
