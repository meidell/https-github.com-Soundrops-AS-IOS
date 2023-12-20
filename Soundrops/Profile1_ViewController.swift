//
//  ProfileViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 06.09.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import CoreData


class Profile1_ViewController: UIViewController {
    
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnAdvertiser: UIButton!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBAction func btnDelete(_ sender: Any) {
                              
        let alert = UIAlertController(title: "Discontinue use", message: "Thank you for using our service. By confirming delete, all your personal and history will be deleted from our systems. Welcome back any time.", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Delete me", style: .default) { (action) in
            c_api.deleterequest(channel: userChannel) { success in
                DispatchQueue.main.async {
                    if success {
                        newUser = true
                        self.performSegue(withIdentifier: "profile1_to_start1", sender: self)
                    } else {
                        let alert1 = UIAlertController(title: "You were not deleted", message: "We are sorry, but there was a technical issue. Try later or contact Soundrops.", preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert1.addAction(okAction)
                        self.present(alert1, animated: true, completion: nil)
                    }
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_dashboard", sender: self)
    }
    @IBAction func btnProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_register2", sender: self)
    }
    @IBAction func btnAudio(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_profile3", sender: self)
    }
    @IBAction func btnAbout(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_profile2", sender: self)
    }
    @IBAction func btnAdvertiser(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_checkid", sender: self)

    }
    @IBAction func btnPolicy(_ sender: Any) {
      //  if let url = URL(string: "https://www.soundrops.com/policy") {
        //    UIApplication.shared.open(url, options: [:])}
    }

    
   override func viewDidLoad() {
        super.viewDidLoad()

        let myColour = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
       
       btnHome.frame.size.width=btnHome.frame.height
       btnHome.backgroundColor = .white
       btnHome.layer.cornerRadius = btnHome.frame.width / 2
       btnHome.layer.borderWidth = 1
       btnHome.layer.borderColor = myColour.cgColor
       btnHome.layer.backgroundColor = white.cgColor
       let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
       let image = UIImage(systemName: "house.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
       btnHome.setImage(image, for: .normal)
       btnHome.imageView?.contentMode = .scaleAspectFit
       
        btnProfile.frame.size.width=btnProfile.frame.height
        btnProfile.layer.cornerRadius = btnProfile.frame.width / 2
        btnProfile.layer.borderWidth = 1
        btnProfile.layer.borderColor = myColour.cgColor
        btnProfile.layer.backgroundColor = white.cgColor
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnProfile.setImage(image1, for: .normal)
        btnProfile.imageView?.contentMode = .scaleAspectFit

        btnAudio.frame.size.width=btnAudio.frame.height
        btnAudio.layer.cornerRadius = btnAudio.frame.width / 2
        btnAudio.layer.borderWidth = 1
        btnAudio.layer.borderColor = myColour.cgColor
        btnAudio.layer.backgroundColor = white.cgColor
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image2 = UIImage(systemName: "speaker.square", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnAudio.setImage(image2, for: .normal)
        btnAudio.imageView?.contentMode = .scaleAspectFit

        btnAbout.frame.size.width=btnAbout.frame.height
        btnAbout.layer.cornerRadius = btnAbout.frame.width / 2
        btnAbout.layer.borderWidth = 1
        btnAbout.layer.borderColor = myColour.cgColor
        btnAbout.layer.backgroundColor = white.cgColor
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "person.2.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnAbout.setImage(image3, for: .normal)
        btnAbout.imageView?.contentMode = .scaleAspectFit

        btnAdvertiser.frame.size.width=btnAdvertiser.frame.height
        btnAdvertiser.layer.cornerRadius = btnAdvertiser.frame.width / 2
        btnAdvertiser.layer.borderWidth = 1
        btnAdvertiser.layer.borderColor = myColour.cgColor
        btnAdvertiser.layer.backgroundColor = white.cgColor
        let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image4 = UIImage(systemName: "iphone", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnAdvertiser.setImage(image4, for: .normal)
        btnAdvertiser.imageView?.contentMode = .scaleAspectFit

        btnPolicy.frame.size.width=btnPolicy.frame.height
        btnPolicy.layer.cornerRadius = btnPolicy.frame.width / 2
        btnPolicy.layer.borderWidth = 1
        btnPolicy.layer.borderColor = myColour.cgColor
        btnPolicy.layer.backgroundColor = white.cgColor
        let largeConfig5 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image5 = UIImage(systemName: "filemenu.and.cursorarrow", withConfiguration: largeConfig5)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnPolicy.setImage(image5, for: .normal)
        btnPolicy.imageView?.contentMode = .scaleAspectFit
       
       btnDelete.frame.size.width=btnDelete.frame.height
       btnDelete.layer.cornerRadius = btnDelete.frame.width / 2
       btnDelete.layer.borderWidth = 1
       btnDelete.layer.borderColor = myColour.cgColor
       btnDelete.layer.backgroundColor = white.cgColor
       let largeConfig6 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
       let image6 = UIImage(systemName: "xmark", withConfiguration: largeConfig6)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
       btnDelete.setImage(image6, for: .normal)
       btnDelete.imageView?.contentMode = .scaleAspectFit
    }
}
