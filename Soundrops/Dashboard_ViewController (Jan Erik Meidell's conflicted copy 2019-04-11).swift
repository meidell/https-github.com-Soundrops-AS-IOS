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
    
    @IBOutlet weak var lbl_thankyou: UILabel!
    @IBOutlet weak var img_rounded_label: UIImageView!
    @IBOutlet weak var img_white_back: UIImageView!
    @IBOutlet weak var img_graph: UIImageView!
    @IBOutlet weak var img_people: UIImageView!
    @IBOutlet weak var lblCommunityName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnNearMe: UIButton!
    @IBOutlet weak var btnCommunity: UIButton!
    @IBOutlet weak var img_background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if d_me["new"] == "1" {
            
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width*0.10, y: self.view.frame.size.height*0.25, width: self.view.frame.size.width*0.8, height: 40))
            toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            toastLabel.textColor = UIColor.darkGray
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "System", size: 12.0)
            toastLabel.text = "Welcome back " + d_me["sd_name"]!
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 7.0, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            d_me["new"]="0"
        }
        
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .denied:
                    self.popupUpdateDialogue1()
                case .authorized:
                    if d_me["notifications"]! == "0" {
                        let urlString1:String = "http://webservice.soundrops.com/REST_set_notification_mode/"+d_me["sd_user_id"]!+"/1"
                        var myrequest = URLRequest(url: URL(string:urlString1)!)
                        myrequest.httpMethod = "GET"
                        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                            guard let _ = data, error == nil else {
                                return
                            }
                        }
                        d_me["notifications"]="1"
                        d_oth["update"] = "yes" 
                        task.resume()
                    }
                case .notDetermined:
                    print("ok")
                case .provisional:
                    print("ok")
                }
            })
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
        
        UIView.animate(withDuration: 0.0, delay: 0, animations: {
            self.img_background.alpha = 0.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.img_background.alpha = 1.0
        }, completion: nil)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if  d_me["sd_org_funds_raised"] == nil {
        } else {
            let myint:Double = Double(d_me["sd_org_funds_raised"]!)!
            let result = formatter.string(from: NSNumber(value: myint))
            self.lblAmount.text = "€ "+result!
            self.lblMembers.text  = d_me["sd_org_number_followers"]!
            self.lblCommunityName.text = d_me["sd_org_name"]?.uppercased()
        }
        
        if Reachability.isConnectedToNetwork(){
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
        }else{
            let alert = UIAlertController(title: "No internet connection!", message: "This app requires internet to work. Please connect and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func popupUpdateDialogue1(){
        
         let urlString1:String = "http://webservice.soundrops.com/REST_set_notification_mode/"+d_me["sd_user_id"]!+"/0"
        var myrequest = URLRequest(url: URL(string:urlString1)!)
        myrequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
            guard let _ = data, error == nil else {
                return
            }
        }
        task.resume()
        d_me["notifications"]="0"

        let alertMessage = "Please go to settings."
        let alert = UIAlertController(title: "Notifications must be switched on", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as! URL)
                }
            }
        })
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func popupUpdateDialogue2(){
        
        let alertMessage = "Please go to settings."
        let alert = UIAlertController(title: "For this function, location services must be switched on", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as! URL)
                }
            }
        })
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            
            g_mod = "adds"
 
            if  d_lst["0:adds"] == nil  || d_oth["update"] == "yes"  {
                loadCampaign()
            } else {
                let trans = CATransition()
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromLeft
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.25
                self.navigationController?.view.layer.add(trans, forKey: nil)
                self.performSegue(withIdentifier: "lists", sender: self)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            g_mod = "near"
          
            if  d_lst["0:near"] == nil  || d_oth["update"] == "yes"  {
                loadCampaign()
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
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            
            let myframe = self.img_rounded_label.frame
            let myframe1 = self.img_white_back.frame
            
            UIView.animate(withDuration: 0.0, delay: 0, animations: {
                self.img_rounded_label.frame.origin.y = myframe.origin.y
                self.img_white_back.frame.origin.y = myframe1.origin.y
            }, completion: nil)
            UIView.animate(withDuration: 0.15, animations: {
                self.img_rounded_label.frame.origin.y = 0
                self.img_white_back.frame.origin.y = 0 + myframe.height

            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(450)) {
                let trans = CATransition()
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromBottom
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.15
                self.navigationController?.view.layer.add(trans, forKey: nil)
                self.performSegue(withIdentifier: "mainToCommunity", sender: self)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
        }
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork(){
            self.performSegue(withIdentifier: "showParameters", sender: self)
        }else{
            let alert = UIAlertController(title: "No internet connection!", message: "This app requires internet to work. Please connect and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnMyAdds(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            g_mod = "adds"
            if  d_oth["update"]! == "yes"  {
                loadCampaign()
            } else {
                if d_lst["0:adds"] == nil  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                        let trans = CATransition()
                        trans.type = CATransitionType.moveIn
                        trans.subtype = CATransitionSubtype.fromLeft
                        trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                        trans.duration = 0.25
                        self.navigationController?.view.layer.add(trans, forKey: nil)
                        self.performSegue(withIdentifier: "lists", sender: self)
                    }
                } else {
                    let trans = CATransition()
                    trans.type = CATransitionType.moveIn
                    trans.subtype = CATransitionSubtype.fromLeft
                    trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    trans.duration = 0.25
                    self.navigationController?.view.layer.add(trans, forKey: nil)
                    self.performSegue(withIdentifier: "lists", sender: self)
                }
            }
        }else{
            let alert = UIAlertController(title: "No internet connection!", message: "This app requires internet to work. Please connect and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func btnNearMe(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                popupUpdateDialogue2()
            case .authorizedAlways, .authorizedWhenInUse:
                if Reachability.isConnectedToNetwork(){
                    
                    g_mod = "near"
                    if  d_oth["update"]! == "yes"  {
                        loadCampaign()
                    } else {
                        
                        if d_lst["0:near"] == nil  {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                                let trans = CATransition()
                                trans.type = CATransitionType.moveIn
                                trans.subtype = CATransitionSubtype.fromRight
                                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                trans.duration = 0.25
                                self.navigationController?.view.layer.add(trans, forKey: nil)
                                self.performSegue(withIdentifier: "lists", sender: self)
                            }
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
                }else{
                    let alert = UIAlertController(title: "No internet connection!", message: "This app requires internet to work. Please connect and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            popupUpdateDialogue2()
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func loadCampaign() {
        
        let activityIndicator = UIActivityIndicatorView(style: .white)
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        // modes...
        // 0:near = cmpid - counter: ord
        // 0:adds = cmpid - counter: ord
        // 0:map = cmpid - counter: co_map
        // 0:follow = cmpid - counter: co_fol
        // 0:near_category = category - counter: co_cat
        // 0:near:shopping = cmpid - counter: co_cac
        
        let myurl: String  = "http://webservice.soundrops.com/REST_get_adds/3/"+d_me["sd_user_id"]!+"/"+d_me["sd_latitude"]!+"/"+d_me["sd_longitude"]!
        var co_fol: Int = 0
        var co_nct: Int = 1
        var co_act: Int = 1
        var co_map: Int = 0
        var mode:String = ""
        var category:String = ""
        var cmpid: String = ""
        var i: Int = 0
        var j: Int = 0
        var k: Int = 0
        var l: Int = 0
        d_oth.removeAll()
        d_lst.removeAll()
        d_cmp.removeAll()
        d_lst["0:adds:cg"]="All"
        d_lst["0:near:cg"]="All"
        d_oth["update"]="no"
        
        //  let myurl1 = "http://webservice.soundrops.com/REST_get_adds/3/rK62VOzslp/58.5555/5.55555"
        
        Alamofire.request(myurl).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                let val : NSObject = JSON["data_result"] as! NSObject;
                if !(val.isEqual(NSNull())) {
                    let JSON1 = JSON["data_result"] as! NSDictionary
                    var max:Int = 0
                    var value:Int = 0
                    for key in JSON1.allKeys {
                        value = Int(key as! String)!
                        if value > max {max=value}
                    }
                    
                    for order in 1001...max {
                        let JSON2 = JSON1[String(order)] as! NSDictionary
                        
                        cmpid = String(JSON2["sd_cmp_id"] as! Int)
                        
                        switch String(JSON2["sd_show_where"] as! Int) {
                        case "2":
                            mode = "near"
                            d_lst[String(j)+":n"]=cmpid
                            j+=1
                            d_lst["near:count"]=String(j)
                        case "3":
                            mode = "both"
                            d_lst[String(j)+":n"]=cmpid
                            j+=1
                            d_lst["near:count"]=String(j)
                            d_lst[String(i)+":a"]=cmpid
                            i+=1
                            d_lst["adds:count"]=String(i)
                        case "4":
                            mode = "community"
                            d_lst[String(k)+":community"]=cmpid
                            k+=1
                            d_lst["community:count"]=String(k)
                        default:
                            mode = "adds"
                            d_lst[String(i)+":a"]=cmpid
                            i+=1
                            d_lst["adds:count"]=String(i)
                        }
                        
                        // campaign info
                        d_cmp[cmpid+":sd_company_city"] = JSON2["sd_company_city"] as? String
                        d_cmp[cmpid+":sd_company_loc_lat"] = String(JSON2["sd_company_loc_lat"] as! Double)
                        d_cmp[cmpid+":sd_company_loc_lon"] = String(JSON2["sd_company_loc_lon"] as! Double)
                        d_cmp[cmpid+":sd_following"] = String(JSON2["following"] as! Bool)
                        d_cmp[cmpid+":sd_company_name"] = String(JSON2["sd_company_name"] as! String)
                        d_cmp[cmpid+":sd_distance"] = String(JSON2["distance"] as! Double)
                        d_cmp[cmpid+":sd_cmp_date_start"] = String(JSON2["sd_cmp_date_start"] as! String)
                        d_cmp[cmpid+":sd_cmp_headline"] = String(JSON2["sd_cmp_headline"] as! String)
                        d_cmp[cmpid+":sd_cmp_id"] = String(JSON2["sd_cmp_id"] as! Int)
                        d_cmp[cmpid+":sd_comp_contact"] = String(JSON2["sd_comp_contact"] as! Int)
                        d_cmp[cmpid+":sd_company_business_model"] = String(JSON2["sd_company_business_model"] as! Int)
                        d_cmp[cmpid+":sd_company_business_category_name"] = String(JSON2["sd_company_business_category_name"] as! String)
                        d_cmp[cmpid+":sd_company_business_sub_category_name"] = String(JSON2["sd_company_business_sub_category_name"] as! String)
                        d_cmp[cmpid+":sd_cmp_image"] = String(JSON2["sd_cmp_image"] as! String)
                        d_cmp[cmpid+":sd_cmp_text"] = String(JSON2["sd_cmp_text"] as! String)
                        d_cmp[cmpid+":sd_cmp_voucher_code"] = String(JSON2["sd_cmp_voucher_code"] as! Int)
                        d_cmp[cmpid+":sd_cmp_voucher_desc"] = String(JSON2["sd_cmp_voucher_desc"] as! String)
                        d_cmp[cmpid+":sd_cmp_voucher_discount"] = String(JSON2["sd_cmp_voucher_discount"] as! Double)
                        d_cmp[cmpid+":sd_cmp_voucher_url"] = String(JSON2["sd_cmp_voucher_url"] as! String)
                        d_cmp[cmpid+":sd_company_id"] = String(JSON2["sd_company_id"] as! Int)
                        d_cmp[cmpid+":sd_company_logo"] = String(JSON2["sd_company_logo"] as! String)
                        d_cmp[cmpid+":sd_company_postcode"] = String(JSON2["sd_company_postcode"] as! String)
                        d_cmp[cmpid+":sd_company_street"] = String(JSON2["sd_company_street"] as! String)
                        d_cmp[cmpid+":used_voucher"] = String(JSON2["used_voucher"] as! Bool)
                        d_cmp[cmpid+":foreign_call_to_action"] = String(JSON2["foreign_call_to_action"] as! Int)
                        d_cmp[cmpid+":sd_show_cmp"] = String(JSON2["sd_show_cmp"] as! Bool)
                        
                        //filter on follows
                        if d_cmp[cmpid+":sd_following"]! == "true"  {
                            d_lst[String(co_fol)+":follow"]=cmpid
                            co_fol+=1
                            d_lst["follow:count"]=String(co_fol)
                        }
                        //filter on map
                        if String(JSON2["sd_show_where"] as! Int) != "4" && d_cmp[cmpid+":sd_company_business_model"]! != "2" &&  (d_cmp[cmpid+":sd_show_cmp"]! == "true" || mode=="near" || mode=="both")  {
                            d_lst[String(co_map)+":map"]=cmpid
                            co_map+=1
                            d_lst["map:count"]=String(co_map)
                            
                        }
                        //filter on categories
                        category = JSON2["sd_company_business_category_name"] as! String
                        //category list
                        if (mode=="adds" || mode=="both") && d_cmp[cmpid+":sd_show_cmp"]! == "true" {
                            if d_oth["adds:"+category]==nil {
                                d_oth["adds:"+category]="1"
                                d_lst[String(co_act)+":adds:cg"]=category
                                co_act+=1
                                d_lst["adds:cg:count"]=String(co_act)
                                d_lst["0:adds:"+category]=cmpid
                                d_oth[category+":adds"]="1"
                                d_lst["adds:"+category+":count"]=d_oth[category+":adds"]
                            } else {
                                d_lst[d_oth[category+":adds"]!+":adds:"+category]=cmpid
                                let i = Int(d_oth[category+":adds"]!)!+1
                                d_oth[category+":adds"]=String(i)
                                d_lst["adds:"+category+":count"]=d_oth[category+":adds"]!                                }
                        }
                        if mode=="near" || mode=="both" {
                            if d_oth["near:"+category]==nil {
                                d_oth["near:"+category]="1"
                                d_lst[String(co_nct)+":near:cg"]=category
                                co_nct+=1
                                d_lst["near:cg:count"]=String(co_nct)
                                d_lst["0:near:"+category]=cmpid
                                d_oth[category+":near"]="1"
                                d_lst["near:"+category+":count"]=d_oth[category+":near"]
                                
                            } else {
                                d_lst[d_oth[category+":near"]!+":near:"+category]=cmpid
                                let i = Int(d_oth[category+":near"]!)!+1
                                d_oth[category+":near"]=String(i)
                                d_lst["near:"+category+":count"]=d_oth[category+":near"]!
                            }
                        }
                    }
                }
                
                // near
                k = 2
                i = 0
                l = 0
                if d_lst["community:count"] == nil {d_lst["community:count"]="0"}
                if d_lst["near:count"] == nil {d_lst["community:count"]="0"}
                if d_lst["near:count"] == nil {d_lst["near:count"]="0"}
                j = Int(d_lst["community:count"]!)!
                var mycount:Int = Int(d_lst["near:count"]!)! - 1
                var distances:[Double] = []
                var mycamps:[Int] = []
                
                if mycount > -1 {
                    for order in 0...mycount {
                        
                        distances.append(Double(d_cmp[d_lst[String(order)+":n"]!+":sd_distance"]!)!)
                        if order == k && l < j {
                            d_lst[String(i)+":near"] = d_lst[String(l)+":community"]!
                            mycamps.append(i)
                            
                            i+=1
                            k+=5
                            l+=1
                        }
                        d_lst[String(i)+":near"] = d_lst[String(order)+":n"]!
                        i+=1
                    }
                    d_lst["near:count"] = String(Int(d_lst["near:count"]!)!+l)
                    distances = distances.sorted()
                    l-=1
                    k=2
                    if l > -1 {
                        for order in 0...l {
                            d_cmp[d_lst[String(order)+":community"]!+":sd_distance"] = String(distances[k])
                            k+=5
                            
                        }
                    }
                }
                
                
                //for
                k = 2
                i = 0
                l = 0
                if d_lst["adds:count"] == nil {d_lst["adds:count"]="0"}
                mycount = Int(d_lst["adds:count"]!)! - 1
                print("herer",mycount)

                if mycount > -1 {
                    for order in 0...mycount {
                        if order == k && l < j {
                            d_lst[String(i)+":adds"] = d_lst[String(l)+":community"]!
                            print("boing",i, d_lst[String(i)+":adds"])

                            i+=1
                            k+=5
                            l+=1
                        }
                        d_lst[String(i)+":adds"] = d_lst[String(order)+":a"]!
                        i+=1
                    }
                    
                    d_lst["adds:count"] = String(Int(d_lst["adds:count"]!)!+l)
                    
                }
            }
            
            activityIndicator.removeFromSuperview()
            if  g_mod == "adds"  {
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
}






