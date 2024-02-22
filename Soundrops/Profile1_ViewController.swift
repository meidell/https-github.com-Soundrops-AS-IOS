//
//  ProfileViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 06.09.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import CoreData
import KeychainSwift


class Profile1_ViewController: UIViewController {
    
    @IBOutlet weak var fldRegistrer: UIButton!
    @IBOutlet weak var fldSlett: UIButton!
    @IBOutlet weak var fldOrganisasjon: UIButton!
    @IBOutlet weak var fldAnnonser: UIButton!
    @IBOutlet weak var fldAnbefal: UIButton!
    @IBOutlet weak var fldPolicy: UIButton!
    @IBOutlet weak var fldVerktoy: UIButton!
    @IBOutlet weak var fldAbout: UIButton!
    @IBOutlet weak var fldProfile: UIButton!
    @IBOutlet weak var share50Icon: UIImageView!
    @IBOutlet weak var btnorganisasjon: UIButton!
    @IBOutlet weak var btnAnnonsorer: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnAdvertiser: UIButton!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAnb: UIButton!
    @IBOutlet weak var btnRegistrer: UIButton!
    @IBOutlet weak var btnQR: UIButton!
    @IBOutlet weak var btnQRAdmin: UIButton!
    
    override func viewDidLoad() {
         super.viewDidLoad()
    
        
        let dist = 45.0
        let adjust = 0.0
        let movex = -2.0
        let myColour = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .small)

        btnProfile.frame.size.width=btnProfile.frame.height
        btnProfile.layer.cornerRadius = btnProfile.frame.width / 2
        btnProfile.layer.borderWidth = 1
        btnProfile.layer.borderColor = myColour.cgColor
        btnProfile.layer.backgroundColor = white.cgColor
        btnProfile.setImage( UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnProfile.imageView?.contentMode = .scaleAspectFit
        btnProfile.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: 150)
        fldProfile.frame.origin.y = btnProfile.frame.origin.y-adjust
        
        btnPolicy.frame.size.width=btnPolicy.frame.height
        btnPolicy.layer.cornerRadius = btnPolicy.frame.width / 2
        btnPolicy.layer.borderWidth = 1
        btnPolicy.layer.borderColor = myColour.cgColor
        btnPolicy.layer.backgroundColor = white.cgColor
        btnPolicy.setImage(UIImage(systemName: "text.bubble.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnPolicy.imageView?.contentMode = .scaleAspectFit
        btnPolicy.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnProfile.frame.origin.y+dist)
        fldPolicy.frame.origin.y = btnPolicy.frame.origin.y-adjust
        
        btnDelete.frame.size.width=btnDelete.frame.height
        btnDelete.layer.cornerRadius = btnDelete.frame.width / 2
        btnDelete.layer.borderWidth = 1
        btnDelete.layer.borderColor = myColour.cgColor
        btnDelete.layer.backgroundColor = white.cgColor
        btnDelete.setImage(UIImage(systemName: "delete.forward.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnDelete.imageView?.contentMode = .scaleAspectFit
        btnDelete.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnPolicy.frame.origin.y+dist)
        fldSlett.frame.origin.y = btnDelete.frame.origin.y-adjust
        
        btnorganisasjon.frame.size.width=btnorganisasjon.frame.height
        btnorganisasjon.layer.cornerRadius = btnorganisasjon.frame.width / 2
        btnorganisasjon.layer.borderWidth = 1
        btnorganisasjon.layer.borderColor = myColour.cgColor
        btnorganisasjon.layer.backgroundColor = white.cgColor
        btnorganisasjon.setImage(UIImage(systemName: "person.3.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnorganisasjon.imageView?.contentMode = .scaleAspectFit
        btnorganisasjon.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnDelete.frame.origin.y+dist+25)
        fldOrganisasjon.frame.origin.y = btnorganisasjon.frame.origin.y-adjust
        
        btnAnb.frame.size.width=btnAnb.frame.height
        btnAnb.layer.cornerRadius = btnAnb.frame.width / 2
        btnAnb.layer.borderWidth = 1
        btnAnb.layer.borderColor = myColour.cgColor
        btnAnb.layer.backgroundColor = white.cgColor
        btnAnb.setImage(UIImage(systemName: "hand.raised.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnAnb.imageView?.contentMode = .scaleAspectFit
        btnAnb.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnorganisasjon.frame.origin.y+dist)
        fldAnbefal.frame.origin.y = btnAnb.frame.origin.y-adjust
        
        btnRegistrer.frame.size.width=btnRegistrer.frame.height
        btnRegistrer.layer.cornerRadius = btnRegistrer.frame.width / 2
        btnRegistrer.layer.borderWidth = 1
        btnRegistrer.layer.borderColor = myColour.cgColor
        btnRegistrer.layer.backgroundColor = white.cgColor
        btnRegistrer.setImage(UIImage(systemName: "pencil.and.ellipsis.rectangle", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        btnRegistrer.imageView?.contentMode = .scaleAspectFit
        btnRegistrer.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnAnb.frame.origin.y+dist)
        fldRegistrer.frame.origin.y = btnRegistrer.frame.origin.y-adjust
        
        btnAnnonsorer.frame.size.width = btnAnnonsorer.frame.height
        btnAnnonsorer.layer.cornerRadius = btnAnnonsorer.frame.width / 2
        btnAnnonsorer.layer.borderWidth = 1
        btnAnnonsorer.layer.borderColor = myColour.cgColor
        btnAnnonsorer.layer.backgroundColor = white.cgColor
        btnAnnonsorer.tintColor = .gray
        btnAnnonsorer.setImage(UIImage(systemName: "signpost.right.and.left.fill", withConfiguration: largeConfig), for: .normal)
        btnAnnonsorer.imageView?.contentMode = .scaleAspectFit
        btnAnnonsorer.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnRegistrer.frame.origin.y+dist+25)
        fldAnnonser.frame.origin.y = btnAnnonsorer.frame.origin.y-adjust
        
        btnAbout.frame.size.width=btnAbout.frame.height
        btnAbout.layer.cornerRadius = btnAbout.frame.width / 2
        btnAbout.layer.borderWidth = 1
        btnAbout.layer.borderColor = myColour.cgColor
        btnAbout.layer.backgroundColor = white.cgColor
        let image3 = UIImage(systemName: "person.2.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnAbout.setImage(image3, for: .normal)
        btnAbout.imageView?.contentMode = .scaleAspectFit
        btnAbout.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnAnnonsorer.frame.origin.y+dist)
        fldAbout.frame.origin.y = btnAbout.frame.origin.y-adjust
        
        btnQR.frame.size.width=btnQR.frame.height
        btnQR.layer.cornerRadius = btnQR.frame.width / 2
        btnQR.layer.borderWidth = 1
        btnQR.layer.borderColor = myColour.cgColor
        btnQR.layer.backgroundColor = white.cgColor
        let image4 = UIImage(systemName: "qrcode", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnQR.setImage(image4, for: .normal)
        btnQR.imageView?.contentMode = .scaleAspectFit
        btnQR.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnAbout.frame.origin.y+dist)
        btnQR.isHidden = true
        
        btnQRAdmin.frame.size.width=btnQRAdmin.frame.height
        btnQRAdmin.layer.cornerRadius = btnQRAdmin.frame.width / 2
        btnQRAdmin.layer.borderWidth = 1
        btnQRAdmin.layer.borderColor = myColour.cgColor
        btnQRAdmin.layer.backgroundColor = white.cgColor
        let image5 = UIImage(systemName: "qrcode", withConfiguration: largeConfig)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        btnQRAdmin.setImage(image5, for: .normal)
        btnQRAdmin.imageView?.contentMode = .scaleAspectFit
        btnQRAdmin.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex+40, y: btnAbout.frame.origin.y+dist)
        btnQRAdmin.isHidden = true
        
//        btnAdvertiser.frame.size.width=btnAdvertiser.frame.height
//        btnAdvertiser.layer.cornerRadius = btnAdvertiser.frame.width / 2
//        btnAdvertiser.layer.borderWidth = 1
//        btnAdvertiser.layer.borderColor = myColour.cgColor
//        btnAdvertiser.layer.backgroundColor = white.cgColor
//        btnAdvertiser.setImage(UIImage(systemName: "iphone.gen1", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
//        btnAdvertiser.imageView?.contentMode = .scaleAspectFit
//        btnAdvertiser.frame.origin = CGPoint(x: share50Icon.frame.origin.x+movex, y: btnAbout.frame.origin.y+dist)
//        fldVerktoy.frame.origin.y = btnAdvertiser.frame.origin.y-adjust
//        
       
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour.cgColor
        btnHome.layer.backgroundColor = white.cgColor
        let image = UIImage(systemName: "house.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
     }
    
    @IBAction func fldSlett(_ sender: Any) {
        btnDelete("#Any#")
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
                              
        let alert = UIAlertController(title: "Du blir nå slettet.", message: "Takk for at du har benyttet vår tjeneste og støttet din organisasjon. Ved å bekrefte sletting vil alle personlige data om din profil bli slettet fra våre systemer. Velkommen tilbake når som helst.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Slett min profil", style: .default) { (action) in
            c_api.deleterequest(channel: userChannel) { success in
                DispatchQueue.main.async {
                    if success {
                        KeychainSwift().delete("channel")
                        myuser = user()
                        self.performSegue(withIdentifier: "profile1_to_start1", sender: self)
                    } else {
                        let alert1 = UIAlertController(title: "Du ble ikke slettet.", message: "Vi beklager, men det oppsto et teknisk problem. Prøv senere eller kontakt oss.", preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert1.addAction(okAction)
                        self.present(alert1, animated: true, completion: nil)
                    }
                }
            }
        }
        let noAction = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func fldRegister(_ sender: Any) {
        btnRegistrer("#Any#")
    }
    
    @IBAction func btnRegistrer(_ sender: Any) {
        if let url2 = URL(string: "https://www.share50.no/orgregshort#1") {
        UIApplication.shared.open(url2, options: [:])}
    }
    
    @IBAction func btnLine(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_animated", sender: self)
    }
    
    @IBAction func fldOrg(_ sender: Any) {
        btnOrganisasjon("#Any#")
    }
    @IBAction func btnQR(_ sender: Any) {
        QRadmin=false
        self.performSegue(withIdentifier: "Profile1_QR_segue", sender: self)

    }
    @IBAction func btnQRAdmin(_ sender: Any) {
        QRadmin=true
        self.performSegue(withIdentifier: "Profile1_QR_segue", sender: self)

    }
    
    @IBAction func btnOrganisasjon(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_community", sender: self)
    }

    @IBAction func fldAnnonsorer(_ sender: Any) {
        btnAnnonsorer("#Any#")
    }
    @IBAction func btnAnnonsorer(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_advertisor", sender: self)
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_dashboard", sender: self)

    }
    @IBAction func fldAnb(_ sender: Any) {
        btnAnb("#Any#")
    }
    @IBAction func btnAnb(_ sender: Any) {
        self.performSegue(withIdentifier: "profile_to_anbefal", sender: self)
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_register2", sender: self)
    }
    @IBAction func fldAbout(_ sender: Any) {
        btnAbout("#Any#")
    }
    
    @IBAction func btnAbout(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_profile2", sender: self)
    }
    @IBAction func fldAvertiser(_ sender: Any) {
        btnAdvertiser("#Any#")
    }
    
    @IBAction func btnAdvertiser(_ sender: Any) {
        self.performSegue(withIdentifier: "profile1_to_checkid", sender: self)

    }
    @IBAction func fldPolicy(_ sender: Any) {
        btnPolicy("#Any#")
    }
    @IBAction func btnPolicy(_ sender: Any) {
        if let url = URL(string: "https://www.share50.no/policy") {
            UIApplication.shared.open(url, options: [:])}
    }
    
 
}
