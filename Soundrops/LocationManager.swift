//
//  LocationManager.swift
//  Soundrops
//
//  Created by JEM on 01.12.2023.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        
        print("Location manager initialized")


        // Set the delegate to receive location updates
        locationManager.delegate = self

        // Request location services authorization
        locationManager.requestWhenInUseAuthorization()

        // Set the desired accuracy and distance filter
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0 // Update location when the user moves by 10 meters

        // Start updating location
        locationManager.startUpdatingLocation()
        
        
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Handle the updated location
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error
        print("Location error: \(error.localizedDescription)")
    }
}


