//
//  DashboardViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 10.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage
import UserNotifications
import PushNotifications

let requestGroup =  DispatchGroup()

class Dashboard_ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnAnnonser: UIButton!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var btnTopTen: UIButton!
    @IBOutlet weak var imgSmiley: UIImageView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnNearby: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnPerks: UIButton!
    @IBOutlet weak var btnFavourites: UIButton!
    @IBOutlet weak var minKamp: UIButton!
    @IBOutlet weak var img_white_back: UIImageView!
    @IBOutlet weak var img_rounded_label: UIImageView!
    @IBOutlet weak var img_graph: UIImageView!
    @IBOutlet weak var img_people: UIImageView!
    @IBOutlet weak var lblCommunityName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var lbl_badge: UILabel!
    @IBOutlet weak var img_background: UIImageView!
    @IBOutlet weak var lblAktiv: UILabel!
    
    
    var notificationSwitch: UISwitch!
    var bGood: Bool = false
    var locationManager: CLLocationManager?
    var isConnectedtoLocalisation: Bool = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        c_api.getrequest(params: "", key: "getadcategories") {
            c_api.getrequest(params: "", key: "getcompetition") {               
            }
        }
        
        bGood = true
        lastView = "Dashboard"

        filldashboard()
       
        if showWarning {
            checkLocationServices()
            checkNotificationServices()
        }
    }
    
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Initialize location manager
            locationManager = CLLocationManager()
            locationManager?.delegate = self

            // Check the current authorization status
            switch locationManager?.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                isConnectedtoLocalisation = true
            case .denied, .restricted:
                isConnectedtoLocalisation = false
                // Optionally, show a custom alert to the user explaining why location services are important
            case .notDetermined:
                // Request authorization for location services when the app is in use
                locationManager?.requestWhenInUseAuthorization()
                isConnectedtoLocalisation = false
            @unknown default:
                isConnectedtoLocalisation = false
            }
        } else {
            // Location services are disabled
            isConnectedtoLocalisation = false
        }

        // Update the UI on the main thread after checking
        DispatchQueue.main.async {
            self.showWarningsIfNeeded()
        }
    }

//
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            let locationManager = CLLocationManager()
//            switch locationManager.authorizationStatus {
//            case .authorizedWhenInUse, .authorizedAlways:
//                isConnectedtoLocalisation = true
//            case .denied, .restricted, .notDetermined:
//                isConnectedtoLocalisation = false
//            @unknown default:
//                isConnectedtoLocalisation = false
//            }
//        } else {
//            isConnectedtoLocalisation = false
//        }
//        
//        DispatchQueue.main.async {
//            self.showWarningsIfNeeded()
//        }
//    }
    
    func checkNotificationServices() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                isConnectedtoNotifications = true
            case .denied, .notDetermined:
                isConnectedtoNotifications = false
            default:
                isConnectedtoNotifications = false
            }
            DispatchQueue.main.async {
                self.showWarningsIfNeeded()
            }
        }
    }

    func showWarningsIfNeeded() {
        
        let screenWidth = UIScreen.main.bounds.width
        if !isConnectedtoLocalisation && showWarning {
            let locationView1 = UIView(frame: CGRect(x: screenWidth*0.1, y: 130, width: screenWidth*0.8, height: 100))
            locationView1.backgroundColor = UIColor.white
            locationView1.layer.cornerRadius = 10
            let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: locationView1.frame.width - 20, height: locationView1.frame.height - 20))
            label1.text = "Lokalisering er skrudd av!\n Skru  på lokalisering for å få bedre treffsikerhet på reklamer."
            label1.font = UIFont.systemFont(ofSize: 16)
            label1.textColor = .darkGray
            label1.numberOfLines = 0
            label1.textAlignment = .center
            locationView1.addSubview(label1)
            view.addSubview(locationView1)
            UIView.animate(withDuration: 0.5, delay: 6.0, options: .curveEaseOut, animations: {
                locationView1.alpha = 0.0
            }, completion: { finished in
                locationView1.removeFromSuperview()
            })
        }
        
        if !isConnectedtoNotifications && showWarning {
            let notificationView2 = UIView(frame: CGRect(x: screenWidth * 0.1, y: 240, width: screenWidth * 0.8, height: 100))
            notificationView2.backgroundColor = UIColor.white
            notificationView2.layer.cornerRadius = 10

            let label2 = UILabel(frame: CGRect(x: 10, y: 10, width: notificationView2.frame.width - 20, height: notificationView2.frame.height - 20))
            label2.text = "Dine varslinger er skrudd av!\nVarslinger må være på for at støttefunksjoner i appen skal fungere."
            label2.font = UIFont.systemFont(ofSize: 16)
            label2.textColor = UIColor.darkGray
            label2.numberOfLines = 0
            label2.textAlignment = .center

            notificationView2.addSubview(label2)
            view.addSubview(notificationView2)

            UIView.animate(withDuration: 0.75, delay: 6.0, options: .curveEaseOut, animations: {
                notificationView2.alpha = 0.0
            }, completion: { finished in
                notificationView2.removeFromSuperview()
            })
        }
        
        showWarning = false
    }
    
    func filldashboard() {
        if currentOrg != myorg.orgid {
            currentOrg = myorg.orgid
            c_api.getrequest(params: "", key: "getmainimages") {
                mainImageCounter = 0
                let imageCount = mainimages?.count ?? 0
                if imageCount > 0 && mainImageCounter < mainimages?.count ?? 0 {
                    AF.request(mainimages![mainImageCounter].image).responseImage { response in
                        switch response.result {
                        case .success(let image):
                            self.img_background.image = image
                        case .failure(let error):
                            print("Error loading image: \(error)")
                        }
                        self.img_background.layer.masksToBounds = true
                        if mainImageCounter == (imageCount-1) {
                            mainImageCounter = 0
                        } else {
                            mainImageCounter += 1
                        }
                    }
                } else {
                    self.img_background.image = UIImage(named:"iStock-893114564")
                    self.img_background.layer.masksToBounds = true
                }
            }
        } else {
            let imageCount = mainimages?.count ?? 0
            if imageCount > 0 && mainImageCounter < mainimages?.count ?? 0 {
                AF.request(mainimages![mainImageCounter].image).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        self.img_background.image = image
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                    self.img_background.layer.masksToBounds = true
                    if mainImageCounter == (imageCount-1) {
                        mainImageCounter = 0
                    } else {
                        mainImageCounter += 1
                    }
                }
            } else {
                self.img_background.image = UIImage(named:"iStock-893114564")
                self.img_background.layer.masksToBounds = true
            }
        }

        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            lbl_badge.frame.size.height = 25
            lbl_badge.frame.size.width = 25
            lbl_badge.backgroundColor = UIColor.red.withAlphaComponent(1)
            lbl_badge.textColor = UIColor.white
            lbl_badge.textAlignment = .center;
            lbl_badge.text = String(UIApplication.shared.applicationIconBadgeNumber)
            lbl_badge.layer.cornerRadius = lbl_badge.frame.width/2
            lbl_badge.clipsToBounds  =  true
            lbl_badge.layer.masksToBounds = true
            lbl_badge.isHidden = false
        } else {
            lbl_badge.isHidden = true
        }
        
        let frame = lblMembers.frame
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        topLayer.backgroundColor = UIColor.gray.cgColor
        lblMembers.layer.addSublayer(topLayer)
        
        let frame1 = lblAmount.frame
        let topLayer1 = CALayer()
        topLayer1.frame = CGRect(x: 0, y: 0, width: frame1.width, height: 1)
        topLayer1.backgroundColor = UIColor.gray.cgColor
        lblAmount.layer.addSublayer(topLayer1)
        
        UIView.animate(withDuration: 0.0, delay: 0, animations: {
            self.img_background.alpha = 0.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.img_background.alpha = 1.0
        }, completion: nil)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
       
        let result = formatter.string(from: NSNumber(value: myorg.orgrevenue))
        self.lblAmount.text = "NOK "+result!
        self.lblMembers.text = String(myorg.orgfollowers)
        self.lblCommunityName.text = myorg.orgname.uppercased()
        
        AF.request(myorg.orglogo).responseImage { response in
            switch response.result {
            case .success(let image):
                let aspectRatio = image.size.width / image.size.height
                let desiredWidth: CGFloat = self.view.bounds.size.width*0.17
                let desiredHeight = desiredWidth / aspectRatio
                self.imgSmiley.frame.size = CGSize(width: desiredWidth, height: desiredHeight)
                self.imgSmiley.center.x = self.view.center.x
                self.imgSmiley.center.y = self.lblCommunityName.center.y - 50
                self.imgSmiley.image = image
                self.imgSmiley.contentMode = .scaleAspectFit
                self.imgSmiley.layer.cornerRadius = 6
                self.imgSmiley.layer.borderWidth = 1
                let myColour8 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                self.imgSmiley.layer.borderColor = myColour8.cgColor
                self.imgSmiley.clipsToBounds = true
            case .failure(let error):
                print("Error loading image: \(error)")
            }

        }

        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        btnAnnonser.layer.cornerRadius = 6
        btnAnnonser.layer.borderWidth = 1
        btnAnnonser.layer.borderColor = myColour.cgColor
        let attributedString1 = NSAttributedString(string: NSLocalizedString("Annonser", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnAnnonser.setAttributedTitle(attributedString1, for: .normal)
      
        
        btnPerks.layer.cornerRadius = 6
        btnPerks.layer.borderWidth = 1
        btnPerks.layer.borderColor = myColour.cgColor
        let attributedString2 = NSAttributedString(string: NSLocalizedString("Fordeler", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnPerks.setAttributedTitle(attributedString2, for: .normal)
        
        btnDel.layer.cornerRadius = 6
        btnDel.layer.borderWidth = 1
        btnDel.layer.borderColor = myColour.cgColor
        let attributedString7 = NSAttributedString(string: NSLocalizedString("Verv en venn", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnDel.setAttributedTitle(attributedString7, for: .normal)
        
        btnTopTen.layer.cornerRadius = 6
        btnTopTen.layer.borderWidth = 1
        btnTopTen.layer.borderColor = myColour.cgColor
        let attributedString8 = NSAttributedString(string: NSLocalizedString("Top 10", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnTopTen.setAttributedTitle(attributedString8, for: .normal)

        btnCategory.layer.cornerRadius = 6
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.borderColor = myColour.cgColor
        let attributedString3 = NSAttributedString(string: NSLocalizedString("Kategorier", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnCategory.setAttributedTitle(attributedString3, for: .normal)

        btnSetting.layer.cornerRadius = 6
        btnSetting.layer.borderWidth = 1
        btnSetting.layer.borderColor = myColour.cgColor
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .small)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnSetting.setImage(image, for: .normal)
        btnSetting.imageView?.contentMode = .scaleAspectFit
        
        btnNearby.layer.cornerRadius = 6
        btnNearby.layer.borderWidth = 1
        btnNearby.layer.borderColor = myColour.cgColor
        let attributedString4 = NSAttributedString(string: NSLocalizedString("Nær meg", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnNearby.setAttributedTitle(attributedString4, for: .normal)
  
        btnFavourites.layer.cornerRadius = 6
        btnFavourites.layer.borderWidth = 1
        btnFavourites.layer.borderColor = myColour.cgColor
        let attributedString5 = NSAttributedString(string: NSLocalizedString("Favoritter", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnFavourites.setAttributedTitle(attributedString5, for: .normal)
        
        lblAktiv.layer.cornerRadius = 6
        lblAktiv.layer.borderWidth = 1
        lblAktiv.layer.borderColor = UIColor.red.cgColor  // Or any custom color
        lblAktiv.clipsToBounds = true
        
        minKamp.layer.cornerRadius = 6
        minKamp.layer.borderWidth = 1
        minKamp.layer.borderColor = myColour.cgColor
        let attributedString9 = NSAttributedString(string: NSLocalizedString("Drakamp", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        minKamp.setAttributedTitle(attributedString9, for: .normal)
        if competitionOn == 1 {
            self.lblAktiv.isHidden = false
            self.minKamp.alpha = 1
            self.minKamp.isEnabled = true
        } else {
            minKamp.alpha = 0.5
            minKamp.isEnabled = false
            lblAktiv.isHidden = true
        }
    }
    
 

    
    @IBAction func btnTipsNoen(_ sender: Any) {
        
        let orgIdString = String(decoding: String(myorg.orgid).data(using: String.Encoding.utf8)!, as: UTF8.self)
        let usernameString = String(decoding: myuser.username.data(using: .utf8)!, as: UTF8.self)
        let data = "orgid#" + orgIdString + "__user#" + usernameString
        
        let encodedData = (data.data(using: .utf8)?.base64EncodedString())!
        let urlString = "https://share50.no/org/" + encodedData
        // Swift code
       // let urlString = "https://vg.no"
        guard let url = URL(string: urlString) else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func areNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .denied:
                completion(false)
            case .notDetermined:
                completion(false)
            case .provisional:
                completion(true)
            case .ephemeral:
                print("missing cases")
            @unknown default:
                completion(false)
            }
        }
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        if bGood {
            self.performSegue(withIdentifier: "dashboard_to_profile1", sender: self)
        }
    }
    
    @IBAction func btnTopTen(_ sender: Any) {
        self.performSegue(withIdentifier: "dashboard_topten", sender: self)
    }

    @IBAction func btnDrakampen(_ sender: Any) {
        self.performSegue(withIdentifier: "dashboard_drakamp", sender: self)
    }
    
    @IBAction func btnFavourites(_ sender: Any) {
        if bGood {
            cmptype="follow"
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
        }
    }
    
    @IBAction func btnMyAdds(_ sender: Any) {
        if bGood {
            UIApplication.shared.applicationIconBadgeNumber = 0
            cmptype = "myads"
            self.performSegue(withIdentifier: "lists", sender: self)
        }
    }
    
    @IBAction func btnPerks(_ sender: Any) {
        if bGood {
            performSegue(withIdentifier: "dashboard_to_perks", sender: self)
        }
    }
    @IBAction func btnDrakamp(_ sender: Any) {
        performSegue(withIdentifier: "dashboard_drakamp", sender: self)
    }
    
    @IBAction func btnNearby(_ sender: Any) {
        if bGood {
            cmptype = "nearby"
            self.performSegue(withIdentifier: "lists", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is Profile1_ViewController {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
        }
    }
}

