import UIKit
import Alamofire
import AlamofireImage
import Accounts
import MessageUI
import CoreLocation

class CampaignDetailViewController: UIViewController {
    
    var data: String = ""
    var window: UIWindow?
    
    var boxView = UIView()
    var updatefollow: Bool = false
    var cmp:String = ""
    
    @IBOutlet weak var img_topborder: UIImageView!
    @IBOutlet weak var img_underneath: UIImageView!
    @IBOutlet weak var img_background: UIImageView!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var lbl_whitealpha: UILabel!
    @IBOutlet weak var img_underneath_lower: UIImageView!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_company: UILabel!
    @IBOutlet weak var textVoucher: UITextView!
    @IBOutlet weak var startTextLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var Action1: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var img_heart: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         if d_lst["0:near"] == nil  && d_cmp["single"] == nil {
            
            LoadInfo()
            
         } else {
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
            
            UIView.animate(withDuration: 0.0, delay: 0, animations: {
                self.img_background.alpha = 0.0
                self.logo.alpha = 0.0
                self.voucherImage.alpha = 0.0
            }, completion: nil)
            
            UIView.animate(withDuration: 1.00, animations: {
                self.img_background.alpha = 0.25
                self.logo.alpha = 1.0
                self.voucherImage.alpha = 1.0
            }, completion: nil)
            
            let myColour2 = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
            
            let frame = share.frame
            let rightLayer = CALayer()
            rightLayer.frame = CGRect(x: frame.width, y: 0, width: 1, height: frame.height)
            rightLayer.backgroundColor = myColour2.cgColor
            share.layer.addSublayer(rightLayer)
            
            let frame1 = Action1.frame
            let topLayer = CALayer()
            topLayer.frame = CGRect(x: 0, y: 0, width: frame1.width, height: 1)
            topLayer.backgroundColor = myColour2.cgColor
            Action1.layer.addSublayer(topLayer)
            
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRect(x: 0, y: frame1.height, width: frame1.width, height: 1)
            bottomLayer.backgroundColor = myColour2.cgColor
            Action1.layer.addSublayer(bottomLayer)
            
            let frame2 = map.frame
            let myLayer = CALayer()
            myLayer.frame = CGRect(x: frame2.width, y: 0, width: 1, height: frame2.height)
            myLayer.backgroundColor = myColour2.cgColor
            map.layer.addSublayer(myLayer)
            
            img_topborder.backgroundColor = UIColor.white
            img_topborder.layer.cornerRadius = 15.0
            img_topborder.layer.borderColor = UIColor.white.cgColor
            img_topborder.layer.borderWidth = 1
            
            if #available(iOS 11.0, *) {
                img_topborder.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            
            img_underneath.layer.cornerRadius = 15.0
            img_underneath.layer.borderColor = UIColor.white.cgColor
            img_underneath.layer.borderWidth = 1
            img_underneath.layer.shadowColor =  UIColor.gray.cgColor
            img_underneath.layer.shadowOpacity = 0.8
            img_underneath.layer.shadowRadius = 1.5
            img_underneath.layer.shadowOffset = CGSize(width: 0, height: 0.8)
            
            img_underneath_lower.layer.cornerRadius = 15.0
            img_underneath_lower.layer.borderColor = UIColor.white.cgColor
            img_underneath_lower.layer.borderWidth = 1
            img_underneath_lower.layer.shadowColor =  UIColor.gray.cgColor
            img_underneath_lower.layer.shadowOpacity = 0.8
            img_underneath_lower.layer.shadowRadius = 1.5
            img_underneath_lower.layer.shadowOffset = CGSize(width: 0, height: 0.8)
            
            if #available(iOS 11.0, *) {
                img_underneath.layer.maskedCorners = [ .layerMinXMinYCorner , .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 11.0, *) {
                img_underneath_lower.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
            
            logo.layer.borderColor = myColour2.cgColor
            logo.layer.borderWidth = 1
            logo.backgroundColor = UIColor.white
            logo.layer.cornerRadius = 15.0
            logo.clipsToBounds = true
            
            if #available(iOS 11.0, *) {
                logo.layer.maskedCorners = [ .layerMaxXMaxYCorner]
            } else {
            }
            voucherImage.layer.borderColor = UIColor.white.cgColor
            voucherImage.layer.borderWidth = 1
            voucherImage.layer.cornerRadius = 15.0
            voucherImage.layer.masksToBounds = true
            voucherImage.clipsToBounds = true
            if #available(iOS 11.0, *) {
                voucherImage.layer.maskedCorners = [  .layerMaxXMaxYCorner, .layerMinXMaxYCorner ]
            } else {
            }
            
            logo.frame.size.height = UIScreen.main.bounds.height*0.100445
            logo.frame.size.width = UIScreen.main.bounds.height*0.100445*1.222222
            logo.frame.origin.y = voucherImage.frame.origin.y + voucherImage.frame.size.height - 20
            startTextLabel.frame.origin.y = voucherImage.frame.origin.y + voucherImage.frame.size.height + 10
            textVoucher.frame.origin.y = voucherImage.frame.origin.y + voucherImage.frame.size.height + 90*(UIScreen.main.bounds.height/896)
            textVoucher.backgroundColor = UIColor.clear
            
            //just in case
            if d_cmp["single"] == nil {d_cmp["single"]="0"}
            
            cmp=d_cmp["single"]!
            
            if d_cmp[cmp+":sd_following"] == "false" {
                img_heart.image = UIImage(named: "heart_1")
            } else {
                img_heart.image = UIImage(named: "heart_2")
            }
            
            print("single campaign",cmp)
            let distanceInMeters = 1000*Double(d_cmp[cmp+":sd_distance"]!)!
            switch d_cmp[cmp+":sd_company_business_model"] {
            case "1" :
                map.isHidden = false
                if distanceInMeters < 1000 {
                    lbl_distance.text = String(format: "%.00f m", distanceInMeters)
                } else {
                    lbl_distance.text = String(format: "%.01f km", distanceInMeters/1000)
                }
            case "2" :
                map.isHidden = true
                lbl_distance.text = "ONLINE"
                
            case "3" :
                map.isHidden = false
                if distanceInMeters < 1000 {
                    lbl_distance.text = String(format: "%.00f m", distanceInMeters)
                } else {
                    lbl_distance.text = String(format: "%.01f km", distanceInMeters/1000)
                }
            case "4" :
                map.isHidden = false
                if distanceInMeters < 1000 {
                    lbl_distance.text = "ONLINE / "+String(format: "%.00f m", distanceInMeters)
                } else {
                    lbl_distance.text = "ONLINE / "+String(format: "%.01f km", distanceInMeters/1000)
                }
            case "5" :
                map.isHidden = false
                if distanceInMeters < 1000 {
                    lbl_distance.text = "SERVICE / "+String(format: "%.00f m", distanceInMeters)
                } else {
                    lbl_distance.text = "SERVICE / "+String(format: "%.01f km", distanceInMeters/1000)
                }
            default :
                map.isHidden = false
                if distanceInMeters < 1000 {
                    lbl_distance.text = String(format: "%.00f m", distanceInMeters)
                } else {
                    lbl_distance.text = String(format: "%.01f km", distanceInMeters/1000)
                }
            }
            
            let frame5 = self.lbl_whitealpha.frame
            let frame6 = self.Action1.frame
            self.startTextLabel.text = d_cmp[cmp+":sd_cmp_headline"]
            self.Action1.setTitle(d_cmp[cmp+":foreign_call_to_action"], for: UIControl.State.normal)
            let myAction = Int(d_cmp[cmp+":foreign_call_to_action"]!)
            
            if myAction == 1 {
                self.img_underneath_lower.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height
                self.img_arrow.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.lbl_distance.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.Action1.setTitle("Voucher", for: .normal)
                self.Action1.isHidden=false
                
                self.lbl_whitealpha.frame = CGRect(origin: CGPoint(x: self.lbl_whitealpha.frame.origin.x, y: self.lbl_whitealpha.frame.origin.y), size: CGSize(width:frame5.width, height:frame5.height*2))
                
            }
            if myAction == 2 {
                self.img_underneath_lower.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height
                self.Action1.setTitle("Go to website url", for: .normal)
                self.Action1.isHidden=false
                self.img_arrow.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.lbl_distance.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.lbl_whitealpha.frame = CGRect(origin: CGPoint(x: self.lbl_whitealpha.frame.origin.x, y: self.lbl_whitealpha.frame.origin.y), size: CGSize(width:frame5.width, height:frame6.height*2))
                
            }
            if myAction == 3 {
                self.img_underneath_lower.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height
                self.Action1.setTitle("Contact me", for: .normal)
                self.Action1.isHidden=false
                self.img_arrow.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.lbl_distance.frame.origin.y = self.Action1.frame.origin.y+Action1.frame.height+11
                self.lbl_whitealpha.frame = CGRect(origin: CGPoint(x: self.lbl_whitealpha.frame.origin.x, y: self.lbl_whitealpha.frame.origin.y), size: CGSize(width:frame5.width, height:frame6.height*2))
            }
            if myAction == 4 || myAction == 0 {
                self.img_underneath_lower.frame.origin.y = self.Action1.frame.origin.y
                self.Action1.setTitle("", for: .normal)
                self.Action1.isHidden=true
                self.img_arrow.frame.origin.y = self.Action1.frame.origin.y+11
                self.lbl_distance.frame.origin.y = self.Action1.frame.origin.y+11
                self.lbl_whitealpha.frame = CGRect(origin: CGPoint(x: self.lbl_whitealpha.frame.origin.x, y: self.lbl_whitealpha.frame.origin.y), size: CGSize(width:frame5.width, height:frame6.height))
            }
            if Int(d_cmp[cmp+":used_voucher"]!) == 1 {
                self.Action1.setTitle("Voucher used", for: .normal)
            }
            self.textVoucher.text = d_cmp[cmp+":sd_cmp_text"]
            self.lbl_company.text? =  d_cmp[cmp+":sd_company_name"]!.uppercased()
            Alamofire.request(d_cmp[cmp+":sd_company_logo"]!).responseImage { response in
                if let image = response.result.value {
                    self.logo.image = image
                }
            }
            Alamofire.request(d_cmp[cmp+":sd_cmp_image"]!).responseImage { response in
                if let image = response.result.value {
                    self.voucherImage.image = image
                }
            }
            
        }
                
        

    }
    
    @IBAction func btn_back(_ sender: Any) {


    }
    
    @IBAction func btnProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "detail_to_profile_segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is Campaign_ViewController {
     
            let trans = CATransition()
            trans.type = CATransitionType.fade
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)

        }
        if segue.destination is Profile1_ViewController {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        if self.Action1.titleLabel?.text == "Go to website url" {
            
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["single"]!+"/3/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
           
            if let url2 = URL(string: d_cmp[cmp+":sd_cmp_voucher_url"]!) {
                UIApplication.shared.open(url2, options: [:])
            }
        }
        if self.Action1.titleLabel?.text == "Contact me" {
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["single"]!+"/4/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
            self.performSegue(withIdentifier: "showContactme", sender: self)
            
        }
        if self.Action1.titleLabel?.text == "Voucher" {
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["single"]!+"/6/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
            self.performSegue(withIdentifier: "showVoucherView", sender: self)
        }
    }
    
    @IBAction func btnFollow(_ sender: Any) {

        var urlString: String
        var k:Int = 0
        
        if d_cmp[cmp+":sd_following"] == "true" {
            for n in 0...300 {
                if d_lst[String(n)+":follow"]==cmp {
                    d_lst[String(n-k)+":follow"]=d_lst[String(n)+":follow"]
                    k=1
                }
            }
            d_lst["follow:count"]=String(Int(d_lst["follow:count"]!)!-1)
            img_heart.image = UIImage(named: "heart_1")
            d_cmp[cmp+":sd_following"] = "false"
            urlString = "http://webservice.soundrops.com/REST_set_unset_following/"+d_me["sd_user_id"]!+"/"+d_cmp[cmp+":sd_company_id"]!+"/0"
        } else {
            urlString = "http://webservice.soundrops.com/REST_set_unset_following/"+d_me["sd_user_id"]!+"/"+d_cmp[cmp+":sd_company_id"]!+"/1"
            
            if d_lst["follow:count"]==nil {d_lst["follow:count"]="0"}
            d_lst[d_lst["follow:count"]!+":follow"]=cmp
            d_lst["follow:count"]=String(Int(d_lst["follow:count"]!)!+1)            
            img_heart.image = UIImage(named: "heart_2")
            d_cmp[cmp+":sd_following"] = "true"
        }
        var myrequest = URLRequest(url: URL(string:urlString)!)
        myrequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
            guard data != nil else {return}
        }
        task.resume()
   
    }
    
    @IBAction func shareFB(_ sender: Any) {
        
        let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+cmp+"/9/0"
        var myrequest = URLRequest(url: URL(string:urlString1)!)
        myrequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
            guard let _ = data, error == nil else {
                return
            }
        }
        task.resume()
        
        let URL_AD = "http://soundrops.no/SOUNDROPS_WEB/UK/Advert.awp?ID="+cmp
        let activityController = UIActivityViewController(activityItems: [URL_AD], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
        
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            
            if d_lst[g_mod+":count"] == nil {d_lst[g_mod+":count"]="0"}
            let i = Int(d_lst[g_mod+":count"]!)! - 1
            g_curr += 1
            if g_curr > i {g_curr=0}
            
            if d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_show_cmp"] != nil  {
                if g_mod.prefix(4) != "near" {
                    while d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_show_cmp"]! == "false" {
                        g_curr += 1
                        if g_curr > i {
                            g_curr=0
                            break
                        }
                    }
                }
                
                
                while d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_company_name"]! == "Soundrops Community" {
                    g_curr += 1
                    if g_curr > i {
                        g_curr=0
                        break
                    }
                }
            }
            if g_curr > i {g_curr=0}
            d_cmp["single"]=d_lst[String(g_curr)+":"+g_mod]!
            self.viewDidLoad()
            self.viewWillAppear(true)
            
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            let i = Int(d_lst[g_mod+":count"]!)! - 1
            
            g_curr -= 1
            if g_curr < 0 {g_curr=i}

            if d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_show_cmp"] != nil {
                if g_mod.prefix(4) != "near"  {
                    while d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_show_cmp"]! == "false" {
                        g_curr -= 1
                        if g_curr < 0 {g_curr=i
                            break
                        }
                    }
                    
                }
              
                while d_cmp[d_lst[String(g_curr)+":"+g_mod]!+":sd_company_name"]! == "Soundrops Community" {
                    g_curr -= 1
                    if g_curr < 0 {g_curr=i
                        break
                    }
                }
                
            }
            if g_curr < 0 {g_curr=i}
            d_cmp["single"]=d_lst[String(g_curr)+":"+g_mod]!
            self.viewDidLoad()
            self.viewWillAppear(false)
        }
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
                            print("add near",order,l,d_lst[String(l)+":community"])
                            
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
                
                if mycount > -1 {
                    for order in 0...mycount {
                        if order == k && l < j {
                            d_lst[String(i)+":adds"] = d_lst[String(l)+":community"]!
                            
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
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targerView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
            rootViewController.pushViewController(targerView, animated: false)
        }
    }
}

