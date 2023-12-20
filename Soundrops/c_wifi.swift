//
//  c_wifi.swift
//  Soundrops
//
//  Created by JEM on 21.11.2023.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import Foundation
import CoreLocation
import Network

var noNet: Bool = false

class c_wifi: NSObject, CLLocationManagerDelegate {

    static func getLocation() {
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        var postcode = 0
        
        locManager.requestWhenInUseAuthorization()
        
        if (locManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
            locManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways){
           currentLocation = locManager.location
            if let currentLocation = currentLocation {
                myuser.userlon = currentLocation.coordinate.longitude
                myuser.userlat = currentLocation.coordinate.latitude
            }
       }
    }

    static func isWiFiConnected() -> Bool {

        let monitor = NWPathMonitor()
        var isConnected = false
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
        semaphore.wait()
        monitor.cancel()

        return isConnected
    }
}
