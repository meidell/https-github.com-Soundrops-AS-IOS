//
//  ContactViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 21/11/2018.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    var contactType: String = ""
    var campaignID: Int = 0
    var userID: String = ""
    var company_name: String = ""
    var data: String = ""
    var mylat: Double=0
    var mylon: Double=0
    var myID: Int = 0
    var uniqueID: String = ""

    
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var img_back_low: UIImageView!
    @IBOutlet weak var img_back_top: UIImageView!
    @IBOutlet weak var lbl_company: UILabel!
    @IBOutlet weak var lbl_back_white: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var fldEmail_Phone: UITextField!
    @IBOutlet weak var btn_back: UIButton!
    @IBAction func btn_back(_ sender: Any) {
         self.performSegue(withIdentifier: "contactToDetails", sender: self)
    }
    
    @IBAction func btn_Settings(_ sender: Any) {
        self.performSegue(withIdentifier: "contact_to_profile_segue", sender: self)
    }
    
    @IBAction func btnSendInfo(_ sender: Any) {
        
        contactType += ":"+self.fldEmail_Phone.text!
        let urlString1:String = "https://webservice.soundrops.com/V1/CONTACT/"+String(campaignID)+"/"+userID+"/"+contactType
        if self.fldEmail_Phone.text != "" {
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
            
            if contactType == "phone" {
                self.lbl_text.text = "Thank you for providing your phone number. You will soon be contacted by one of our staff members"
            } else {
                self.lbl_text.text = "Thank you for providing your email. You will soon be contacted by one of our staff members"
            }
            
            let key = d_cmp["single"]!+d_me["mode"]!
            let urlString1:String = "https://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp[key+":sd_cmp_id"]!+"/5/0"
            var myrequest1 = URLRequest(url: URL(string:urlString1)!)
            myrequest1.httpMethod = "GET"
            let task1 = URLSession.shared.dataTask(with: myrequest1) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task1.resume()
          
            
            self.view.endEditing(true)

            UIView.animate(withDuration: 0.0, delay: 0, animations: {
                self.fldEmail_Phone.alpha = 1
                self.btnSend.alpha = 1
                self.lbl_text.alpha = 0
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, animations: {
                self.fldEmail_Phone.alpha = 0
                self.btnSend.alpha = 0
                self.lbl_text.alpha = 1

            }, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Empty field", message: "Fill in your " + contactType, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    print("default")
                }}))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is CampaignDetailViewController {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            
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
            self.performSegue(withIdentifier: "contact_to_dashboard_segue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        lbl_company.text = company_name.uppercased()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if contactType == "phone" {
            self.fldEmail_Phone.placeholder = "Enter your phone number"
            self.lbl_text.text = " We would like to contact you by phone. Please enter your phone number."
        } else {
            self.fldEmail_Phone.placeholder = "Enter your email"
            self.lbl_text.text = " We would like to contact you by phone. Please enter your email."
        }
            
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        img_back_top.layer.cornerRadius = 15.0
        img_back_top.layer.borderColor = myColour2.cgColor
        img_back_top.layer.borderWidth = 1
        
        let frame1 = img_back_top.frame
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: frame1.height, width: frame1.width, height: 1)
        topLayer.backgroundColor = UIColor.white.cgColor
        img_back_top.layer.addSublayer(topLayer)
        
//        img_back_top.layer.shadowColor =  UIColor.gray.cgColor
//        img_back_top.layer.shadowOpacity = 0.8
//        img_back_top.layer.shadowRadius = 1.5
//        img_back_top.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        if #available(iOS 11.0, *) {
            img_back_top.layer.maskedCorners = [ .layerMinXMinYCorner , .layerMaxXMinYCorner]
        } else {
                    // Fallback on earlier versions
        }
        
        btnSend.layer.borderWidth = 1
        btnSend.layer.borderColor = myColour2.cgColor
        
        fldEmail_Phone.layer.borderWidth = 1
        fldEmail_Phone.layer.borderColor = myColour2.cgColor
                
        img_back_low.layer.cornerRadius = 15.0
        img_back_low.layer.borderColor = UIColor.white.cgColor
        img_back_low.layer.borderWidth = 1
        img_back_low.layer.shadowColor =  UIColor.gray.cgColor
        img_back_low.layer.shadowOpacity = 0.8
        img_back_low.layer.shadowRadius = 1.5
        img_back_low.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        if #available(iOS 11.0, *) {
            img_back_low.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        fldEmail_Phone.backgroundColor = UIColor.white
        fldEmail_Phone.layer.borderWidth = 1
        fldEmail_Phone.layer.borderColor = myColour2.cgColor
        fldEmail_Phone.layer.cornerRadius = 2.0
        fldEmail_Phone.layer.shadowColor = myColour2.cgColor
        fldEmail_Phone.layer.shadowOpacity = 0.5
        fldEmail_Phone.layer.shadowRadius = 1.2
        fldEmail_Phone.layer.shadowOffset = CGSize(width: 0, height: 2)

    }
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fldEmail_Phone.resignFirstResponder()
        return (true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 150
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
   
}
