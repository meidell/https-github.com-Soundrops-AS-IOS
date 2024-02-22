//
//  Startbefore_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 30.01.2024.
//  Copyright © 2024 Jan Erik Meidell. All rights reserved.
//

import UIKit
import PushNotifications
import CoreLocation

class Startbefore_ViewController: UIViewController, CLLocationManagerDelegate {
    
    let pushNotifications = PushNotifications.shared
    let locationManager = CLLocationManager()

    @IBOutlet weak var btnContinue: UIButton!
    
    @IBAction func btnContinue(_ sender: Any) {
        self.performSegue(withIdentifier: "startbefore_to_start1", sender: self)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestNotificationAuthorization()
        self.requestLocationAuthorization()
      
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnContinue.layer.cornerRadius = 5.0
        btnContinue.layer.borderColor = myColour2.cgColor
        btnContinue.layer.borderWidth = 1
        btnContinue.backgroundColor = UIColor.lightGray
        btnContinue.titleLabel?.textColor = UIColor.white
                
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Videre", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btnContinue.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func requestLocationAuthorization() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    

    
    private func requestNotificationAuthorization() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
//            if granted {
//                DispatchQueue.main.async {
//                    self?.dismiss(animated: true, completion: nil)
//                }
//                isConnectedtoNotifications=true
//            } else {
//                isConnectedtoNotifications=false
//            }
//            self!.requestLocationAuthorization()
//        }
    }
}
