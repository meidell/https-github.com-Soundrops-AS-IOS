//
//  c_locationmanager.swift
//  Soundrops
//
//  Created by JEM on 30.11.2023.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import CoreLocation


class c_locationmanager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
}

extension c_locationmanager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didchangeAutorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notdetermined")
        case .restricted:
            print("notdetermined")
        case .denied:
            print("notdetermined")
        case .authorizedAlways:
            print("notdetermined")
        case .authorizedWhenInUse:
            print("notdetermined")
        @unknown default:
            break
        }
        
    }
    

}
