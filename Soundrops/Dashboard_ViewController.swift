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
    
    @IBOutlet weak var imgSmile: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnNearby: UIButton!
    @IBOutlet weak var btnMyadds: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnPerks: UIButton!
    @IBOutlet weak var btnAdvertisors: UIButton!
    @IBOutlet weak var btnFavourites: UIButton!
    @IBOutlet weak var img_white_back: UIImageView!
    @IBOutlet weak var fldCopyright: UILabel!
    @IBOutlet weak var img_rounded_label: UIImageView!
    @IBOutlet weak var img_graph: UIImageView!
    @IBOutlet weak var img_people: UIImageView!
    @IBOutlet weak var lblCommunityName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var lbl_badge: UITextField!
 
    @IBOutlet weak var img_background: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        c_api.getrequest(params: "", key: "getadcategories") {
        }
        
        filldashboard()
        
        if isConnectedtoWifi {
            c_wifi.getLocation()
            if !isConnectedtoWifi {
                let alert = UIAlertController(title: "Ingen internettforbindelse!", message: "Denne appen trenger internett for å kunne brukes. Koble deg til og prøv igjen.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
        } else {
            
            let alert = UIAlertController(title: "Ingen internettforbindelse!", message: "Denne appen trenger internett for å kunne brukes. Koble deg til og prøv igjen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func filldashboard() {
        
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
        
        let frame = lblMembers.frame //Frame of label
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        topLayer.backgroundColor = UIColor.gray.cgColor
        lblMembers.layer.addSublayer(topLayer)
        
        let frame1 = lblAmount.frame //Frame of label
        let topLayer1 = CALayer()
        topLayer1.frame = CGRect(x: 0, y: 0, width: frame1.width, height: 1)
        topLayer1.backgroundColor = UIColor.gray.cgColor
        lblAmount.layer.addSublayer(topLayer1)
        
        
        if ((mainimages?[mainImageCounter].image) == nil) {
            self.img_background.image = UIImage(named:"iStock-893114564")
            self.img_background.layer.masksToBounds = true
        } else {
            Alamofire.request(mainimages![mainImageCounter].image).responseImage { response in
                self.img_background.image = response.result.value
                self.img_background.layer.masksToBounds = true
                if mainImageCounter == 2 {
                    mainImageCounter = 0
                } else {
                    mainImageCounter += 1
                }
            }
        }


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
    
        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        btnMyadds.backgroundColor = .clear
        btnMyadds.layer.cornerRadius = 6
        btnMyadds.layer.borderWidth = 1
        btnMyadds.layer.borderColor = myColour.cgColor
        let attributedString1 = NSAttributedString(string: NSLocalizedString("Mine tilbud", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnMyadds.setAttributedTitle(attributedString1, for: .normal)
        
        btnPerks.backgroundColor = .clear
        btnPerks.layer.cornerRadius = 6
        btnPerks.layer.borderWidth = 1
        btnPerks.layer.borderColor = myColour.cgColor
        let attributedString2 = NSAttributedString(string: NSLocalizedString("Perks", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnPerks.setAttributedTitle(attributedString2, for: .normal)

        btnCategory.backgroundColor = .clear
        btnCategory.layer.cornerRadius = 6
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.borderColor = myColour.cgColor
        let attributedString3 = NSAttributedString(string: NSLocalizedString("Kategorier", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnCategory.setAttributedTitle(attributedString3, for: .normal)
 
        btnSetting.backgroundColor = .clear
        btnSetting.layer.cornerRadius = 6
        btnSetting.layer.borderWidth = 1
        btnSetting.layer.borderColor = myColour.cgColor
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .small)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        btnSetting.setImage(image, for: .normal)
        btnSetting.imageView?.contentMode = .scaleAspectFit
        
        btnNearby.backgroundColor = .clear
        btnNearby.layer.cornerRadius = 6
        btnNearby.layer.borderWidth = 1
        btnNearby.layer.borderColor = myColour.cgColor
        let attributedString4 = NSAttributedString(string: NSLocalizedString("Nær meg", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnNearby.setAttributedTitle(attributedString4, for: .normal)
        
        btnFavourites.backgroundColor = .clear
        btnFavourites.layer.cornerRadius = 6
        btnFavourites.layer.borderWidth = 1
        btnFavourites.layer.borderColor = myColour.cgColor
        let attributedString5 = NSAttributedString(string: NSLocalizedString("Favoritter", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnFavourites.setAttributedTitle(attributedString5, for: .normal)
        
        let attributedString6 = NSAttributedString(string: NSLocalizedString("ANNONSØRER", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnAdvertisors.setAttributedTitle(attributedString6, for: .normal)
        
    }
    
    func popupUpdateDialogue1(){
        
        userNotification = "0"
        let alertMessage = "Vennligst gå til innstillinger."
        let alert = UIAlertController(title: "Vi la merke til at varsler er deaktivert. Dette betyr at innsamlingspotensialet er begrenset. I mellomtiden kan du gjerne dra nytte av de mange gode tilbudene i denne appen.", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl!)
                }
            }
        })
        let laterBtn = UIAlertAction(title: "Senere", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            saidLater = true
        })
        alert.addAction(okBtn)
        alert.addAction(laterBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func popupUpdateDialogue2(){
        
        let alertMessage = "Vennligst gå til innstillinger."
        let alert = UIAlertController(title: "For denne funksjonen må lokaliseringstjenester være slått på.", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl!)
                }
            }
        })
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
                        
            cmptype = "myads"
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
           
            cmptype = "nearby"
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromRight
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            UIView.animate(withDuration: 0.2, animations: {
                self.img_rounded_label.frame.origin.y = 0
                self.img_white_back.frame.origin.y = 0

            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                let trans = CATransition()
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromBottom
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.2
                self.navigationController?.view.layer.add(trans, forKey: nil)
                self.performSegue(withIdentifier: "mainToCommunity", sender: self)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
        }
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork(){
            self.performSegue(withIdentifier: "dashboard_to_profile1", sender: self)
        }else{
            let alert = UIAlertController(title: "Ingen internettforbindelse!", message: "Denne appen trenger internett for å kunne brukes. Koble deg til og prøv igjen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnFavourites(_ sender: Any) {
        
        cmptype="follow"
       // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
     //   }
    }
    
    @IBAction func btnMyAdds(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            UIApplication.shared.applicationIconBadgeNumber = 0
            cmptype = "myads"
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
        }else{
            let alert = UIAlertController(title: "Ingen internettforbindelse!", message: "Denne appen trenger internett for å kunne brukes. Koble deg til og prøv igjen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPerks(_ sender: Any) {
              performSegue(withIdentifier: "dashboard_to_perks", sender: self)
    }
    
    @IBAction func btnNearby(_ sender: Any) {
        
        cmptype = "nearby"
        let trans = CATransition()
        trans.type = CATransitionType.moveIn
        trans.subtype = CATransitionSubtype.fromRight
        trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        trans.duration = 0.25
        self.navigationController?.view.layer.add(trans, forKey: nil)
        self.performSegue(withIdentifier: "lists", sender: self)
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func loadCampaign() {

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()

        activityIndicator.removeFromSuperview()
        if  cmptype == "myads"  {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)

        } else {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromRight
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "lists", sender: self)
        }

    }
}






