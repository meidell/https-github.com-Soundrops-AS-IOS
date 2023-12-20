//
//  CommunityViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 23.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Community_ViewController: UIViewController {
        
    @IBOutlet weak var lblOrganisation: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var lbl_soundrops_communit: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnTell: UIButton!
    @IBOutlet weak var lblFunds: UILabel!
    @IBOutlet weak var textCommunity: UILabel!
    @IBOutlet weak var imageCommunity: UIImageView!
    
    @IBOutlet var btnSmile: UIView!
    
    @IBAction func btnMyPage(_ sender: Any) {
        self.performSegue(withIdentifier: "community_to_mypage", sender: self)
    }
    
    @IBAction func btnTell(_ sender: Any) {
        
        let URL_AD = "https://share50.no"
        let activityController = UIActivityViewController(activityItems: [URL_AD], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {self.navigationController?.isNavigationBarHidden = true}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(myorg.orglogo).responseImage { response in
            let image = response.result.value
            self.logo.image = image
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let result = formatter.string(from: NSNumber(value: myorg.orgrevenue))
        self.lblFunds.text = "NOK "+result!
        self.lblMembers.text = String(myorg.orgfollowers)
        self.lblOrganisation.text = myorg.orgname
        
//        let bottomLayer = CALayer()
//        bottomLayer.frame = CGRect(x: 0, y: lblOrganisation.frame.height, width: lblOrganisation.frame.width, height: 1)
//        bottomLayer.backgroundColor = UIColor.lightGray.cgColor
//        self.lblOrganisation.layer.addSublayer(bottomLayer)
        
        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        btnTell.layer.cornerRadius = 6
        btnTell.layer.borderWidth = 1
        btnTell.layer.borderColor = myColour.cgColor
        let attributedString4 = NSAttributedString(string: NSLocalizedString("Tell Somebody", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnTell.setAttributedTitle(attributedString4, for: .normal)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
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
        
        logo.layer.cornerRadius = 5.0
        logo.clipsToBounds = true
        
        imageCommunity.layer.cornerRadius = 5.0
        imageCommunity.clipsToBounds = true
        
        let myColour1 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnHome.backgroundColor = .clear
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour.cgColor
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image = UIImage(systemName: "house.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        
        if d_me["sd_org_change"] == "true" {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width*0.10, y: self.view.frame.size.height*0.4, width: self.view.frame.size.width*0.8, height: 100))
            toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            toastLabel.textColor = UIColor.darkGray
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "System", size: 12.0)
            toastLabel.text = "Thank you for your support."
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 3
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 7.0, delay: 1.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            d_me["sd_org_change"]="false"

        }

    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let trans = CATransition()
            trans.type = CATransitionType.push
            trans.subtype = CATransitionSubtype.fromTop
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "community_to_dashboard", sender: self)
       }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            let trans = CATransition()
            trans.type = CATransitionType.push
            trans.subtype = CATransitionSubtype.fromBottom
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "community_to_dashboard", sender: self)
        }
    }
}
