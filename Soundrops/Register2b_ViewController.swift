//
//  Register2b_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 26.02.19.
//  Copyright © 2019 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


class Register2b_ViewController: UIViewController {
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var fld_phone: UITextField!
    @IBOutlet weak var fld_code: UITextField!
    @IBOutlet weak var lbl_white_alpha: UILabel!
    @IBOutlet weak var img_top_border: UIImageView!
    @IBOutlet weak var img_bottom_border: UIImageView!
    
    var password: String = ""
    var n: Int = 0
    var phone_number_exists:Bool = false
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        password = randomAlphaNumericString(length: 5)

        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnSend.layer.cornerRadius = 5.0
        btnSend.layer.borderColor = myColour2.cgColor
        btnSend.layer.borderWidth = 1
        
        fld_phone.layer.cornerRadius = 5.0
        fld_phone.layer.borderColor = myColour2.cgColor
        fld_phone.layer.borderWidth = 1
        
        fld_code.layer.cornerRadius = 5.0
        fld_code.layer.borderColor = myColour2.cgColor
        fld_code.layer.borderWidth = 1
        
        // test
        if #available(iOS 12.0, *) {
            fld_code.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
    }
    
   
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Soundrops")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveuser() {
        
        //get the user channel from the local database
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(d_me["sd_user_id"]!, forKey: "channel")
                do {
                    try context.save()
                } catch {
                }
            }
        } catch {
        }
        
        //get user data from server
        let urlString1:String = "https://webservice.soundrops.com/REST_get_user_data/"+d_me["sd_user_id"]!
        let encoded = urlString1.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)
        Alamofire.request(url!).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                let val : NSObject = JSON["data_result"] as! NSObject;
                if !(val.isEqual(NSNull())) {
                    let JSON1 = JSON["data_result"] as! NSDictionary
                    d_me["sd_name"] = String(JSON1["sd_user_name"] as! String)
                    d_me["sd_age"] = String(JSON1["sd_user_age"] as! Int)
                    d_me["sd_gender"] = String(JSON1["sd_user_gender"] as! Int)
                    d_me["sd_accept"] = String(JSON1["sd_user_accept"] as! Bool)
                    d_me["sd_audio"] = String(JSON1["sd_user_audio"] as! Bool)
                    d_me["sd_org_id"] = String(JSON1["sd_user_org"] as! Int)
                    d_me["sd_org_name"] = String(JSON1["sd_org_name"] as! String)
                    d_me["sd_org_id"] = String(JSON1["sd_org_id"] as! Int)
                    d_me["sd_org_description"] = String(JSON1["sd_org_description"] as! String)
                    d_me["sd_org_image_logo"] = String(JSON1["sd_org_image_logo"] as! String)
                    d_me["sd_org_image"] = String(JSON1["sd_org_image"] as! String)
                    d_me["sd_org_number_followers"] = String(JSON1["sd_org_number_followers"] as! String)
                    d_me["sd_org_funds_raised"] = String(JSON1["sd_org_funds_raised"]! as! Double)
                    d_me["sd_user_active"] = String(JSON1["sd_user_active"]! as! Bool)
                }
            }
             d_me["new"]="1"
            self.performSegue(withIdentifier: "register2b_to_dashboard", sender: self)
        }
    }
    
    @IBAction func btnSend(_ sender: Any) {
        phone = fld_phone.text!
        if btnSend.titleLabel?.text == "Send" {
            d_me["sd_phone"] = phone
            if !(fld_phone.text == "") {
                let url:String = "https://webservice.soundrops.com/REST_validate_phone/"+phone
                Alamofire.request(url).responseJSON { response in
                    if let json = response.result.value {
                        let JSON = json as! NSDictionary
                        let val : NSObject = JSON["data_result"] as! NSObject;
                        if !(val.isEqual(NSNull())) {
                            let myanswer: String = String(JSON["data_result"] as! String)
                            if myanswer == "1" {
                                self.phone_number_exists = true
                            }
                        }
                    }
                    if self.phone_number_exists {
                        let alert = UIAlertController(title: "Number allready exists.", message: "Do you want to log on with this phone number? (Click YES and login with password received in sms from your primary phone)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                              let sChaineNO: String = "https://sveve.no/SMS/SendMessage?user=lexigosr&passwd=Artikkelnr1&to="+self.phone+"&msg="+self.password
                            
                            var myrequest = URLRequest(url: URL(string:sChaineNO)!)
                            myrequest.httpMethod = "GET"
                            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                                guard let _ = data, error == nil else {
                                    return
                                }
                            }
                            task.resume()
                            UIView.animate(withDuration: 1, animations: {
                                self.fld_phone.isHidden = true
                                self.fld_code.isHidden = false
                                self.btnSend.setTitle("Verify", for: .normal)
                                let myColour = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                                self.btnSend.backgroundColor = myColour
                            }, completion: nil)

                        }))
                        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "segue_2b_to_start", sender: self)
                        }))
                        self.present(alert, animated: true)
                        
                    } else {
                        let sChaineNO: String = "https://sveve.no/SMS/SendMessage?user=lexigosr&passwd=Artikkelnr1&to="+self.phone+"&msg="+self.password
                        var myrequest = URLRequest(url: URL(string:sChaineNO)!)
                        myrequest.httpMethod = "GET"
                        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                            guard let _ = data, error == nil else {
                                return
                            }
                        }
                        task.resume()
                        UIView.animate(withDuration: 1, animations: {
                            self.fld_phone.isHidden = true
                            self.fld_code.isHidden = false
                            self.btnSend.setTitle("Verify", for: .normal)
                            let myColour = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                            self.btnSend.backgroundColor = myColour
                        }, completion: nil)
                    }
                }
            }
        } else {
            if fld_code.text! == password {
                 if self.phone_number_exists {
                    let url:String = "https://webservice.soundrops.com/REST_get_user_exists/0/0/"+self.phone
                    Alamofire.request(url).responseJSON { response in
                        if let json = response.result.value {
                            let JSON = json as! NSDictionary
                            let val : NSObject = JSON["data_result"] as! NSObject;
                            if !(val.isEqual(NSNull())) {
                                let myanswer: String = String(JSON["data_ok"] as! Bool)
                                if myanswer == "true" {
                                    let JSON1 = JSON["data_result"] as! NSDictionary
                                    d_me["sd_user_id"] = String(JSON1["channel_overwrite"] as! String)
                                    self.saveuser()
                                } else {
                                    self.performSegue(withIdentifier: "segue_2b_to_clubs", sender: self)
                                }
                            }
                        }
                    }
                    
                 } else {
                    performSegue(withIdentifier: "segue_2b_to_clubs", sender: self)
                }
            } else {
                if n > 1 {
                    performSegue(withIdentifier: "segue_2b_to_start", sender: self)
                } else {
                    n+=1
                    let alert = UIAlertController(title: "Wronge code.", message: "You have "+String(3-n)+" more attemps.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
}
