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
    
    static func checkandGetLocation() {
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        
        if myuser.userlat == 0 {
            myuser.userlon = 58.97097
            myuser.userlat =  5.73107
        }
       
        if (locManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
            locManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways){
           currentLocation = locManager.location
            if let currentLocation = currentLocation {
                myuser.userlon = currentLocation.coordinate.longitude
                myuser.userlat = currentLocation.coordinate.latitude
            }
        }
    }

    static func isWiFiConnected() {

        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            isConnectedtoWifi = path.status == .satisfied
            semaphore.signal()
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
        semaphore.wait()
        monitor.cancel()
    }
}
