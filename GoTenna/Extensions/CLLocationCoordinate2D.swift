//
//  CLLocationCoordinate2D.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/26/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func getDistanceInMiles(userLocation: CLLocationCoordinate2D, locationLat: Double, locationLon: Double) -> Double {
        var distance = 0.0
        let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let placeLocation = CLLocation(latitude: locationLat, longitude: locationLon)
        let distanceInMeters = userLocation.distance(from: placeLocation)
        distance = distanceInMeters/1609.0
        return distance
    }
}
