import UIKit
import CoreData
import UserNotifications
import PushNotifications
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import Alamofire
import SystemConfiguration


//org info
//var d_org = [String: String]()
// campaign details
var d_cmp = [String: String]()
// lists for tables
var d_lst = [String: String]()
// personal info
var d_me = [String: String]()
// other stuff
var d_oth = [String: String]()

// modes
var g_mod: String = "adds"
var g_omd: String = ""
var g_curr: Int = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    var locationManager:CLLocationManager!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        d_oth["update"] = "no"
        d_me["sd_longitude"]="55"
        d_me["sd_latitude"]="6"
        d_me["notifications"]="1"
        d_me["sd_accept"]="false"
        
        if launchOptions != nil{
            // opened from a push notification when the app is closed
            let notificationPayload: NSDictionary  = launchOptions! as NSDictionary
            let mydict: NSDictionary = notificationPayload["UIApplicationLaunchOptionsRemoteNotificationKey"]! as! NSDictionary
            let mydict1: NSDictionary = mydict["data"]! as! NSDictionary
            for (key,value) in mydict1 {
                let mykey = key as! String
                if mykey == "campaign-id" {
                    let thisone = value as! Int
                    d_me["single"] = String(thisone)
                }
            }
        }
        
        //get the user channel from the local database
        var count: Int = 0
        var i: Int = 0
        let context = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        i = 0
        do {
            count = try context.count(for: request)
        } catch {
        }
        if count > 1 {
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {

                    i+=1
                    context.delete(data)
                    if i > 1 {context.delete(data)}
                }
                try context.save()
            } catch {
            }
        }
        
        if count == 0 {
            //if not yet registered, then create a channel and save it locally
            //channel registration with remote push happens in appdelegate
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User",into: context)
            newUser.setValue(randomAlphaNumericString(length: 10), forKey:"channel")
            do {
                try context.save()
            } catch {
            }
        }
        
        i = 0
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                d_me["sd_user_id"] = data.value(forKey: "channel") as? String
                d_me["audio"] = data.value(forKey: "audio") as? String
            }
        } catch {
        }
        
        //get user data from server
        if !(d_me["sd_user_id"] == "0") {
            
            let urlString1:String = "http://webservice.soundrops.com/REST_get_user_data/"+d_me["sd_user_id"]!
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
                    }
                }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized:Bool, error:Error?) in
        }
        
        //pushnotifications
        
        //  den gamle kanalen self.pushNotifications.start(instanceId: "554e2131-455d-4b9f-9d9e-7a3320c363c0")
        self.pushNotifications.start(instanceId: "01951d5b-82d4-4b3c-a9d1-dca0353072fd")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: d_me["sd_user_id"]!)
        
        
        //google login
        GIDSignIn.sharedInstance()?.clientID = "2478859469-lres65uhil6ca8vs52gq2os3ddd9f0pr.apps.googleusercontent.com"
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        GMSPlacesClient.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        
        //first call
        let answerOne = UNNotificationAction(identifier: "answerOne",
                                             title: "Open Voucher",
                                             options: [.foreground])
        
        
        let oneCategory = UNNotificationCategory(identifier: "oneCategory",
                                                 actions: [answerOne],
                                                 intentIdentifiers: [],
                                                 options: [])
        //second category web
        let answerTwo = UNNotificationAction(identifier: "answerTwo",
                                             title: "Website",
                                             options: [.foreground])
        
        let twoCategory = UNNotificationCategory(identifier: "twoCategory",
                                                 actions: [answerTwo],
                                                 intentIdentifiers: [],
                                                 options: [])
        //third category contact
        let answerThree = UNNotificationAction(identifier: "answerThree",
                                               title: "Contact Me",
                                               options: [.foreground])
        
        let threeCategory = UNNotificationCategory(identifier: "threeCategory",
                                                   actions: [answerThree],
                                                   intentIdentifiers: [],
                                                   options: [])
        //fourth category yes/no
        let answerFour = UNNotificationAction(identifier: "answerFour",
                                              title: "Yes",
                                              options: [.foreground])
        
        let answerFive = UNNotificationAction(identifier: "answerFive",
                                              title: "No",
                                              options: [.foreground])
        
        let fourCategory = UNNotificationCategory(identifier: "fourCategory",
                                                  actions: [answerFour, answerFive],
                                                  intentIdentifiers: [],
                                                  options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [oneCategory,twoCategory,threeCategory,fourCategory])
        application.registerForRemoteNotifications()
        

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //this method is only called when the app is in the foreground
        if d_me["audio"] == nil {d_me["audio"] = "true"}
        if d_me["audio"]! == "true" {
            completionHandler([.alert, .badge, .sound])
        } else {
            completionHandler([.alert, .badge])
        }
        completionHandler([.alert, .badge, .sound])
        
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


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        self.pushNotifications.registerDeviceToken(deviceToken)
        //just to check
        if d_me["sd_user_id"] == nil {d_me["sd_user_id"]=""}
       // try? self.pushNotifications.addDeviceInterest(interest: d_me["sd_user_id"]!)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //alert here
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let action = response.actionIdentifier
        let request = response.notification.request
        if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
            print(PusherNotificationData)
            d_me["single"]  = String(PusherNotificationData["campaign-id"] as! Int)
        }
        
        d_cmp["adds:update"] = "yes"

        if action == "answerOne"{
        }

        if action == "answerTwo"{
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["sd_cmp_id"]!+"/3/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()

            if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
                if let siteData = PusherNotificationData["site-url"] as? String {
                    if let url = URL(string: siteData) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }

        if action == "answerThree"{
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["sd_cmp_id"]!+"/5/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()

            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targerView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
            rootViewController.pushViewController(targerView, animated: false)
        }

        if action == "answerFour"{
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["sd_cmp_id"]!+"/7/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
        }

        if action == "answerFive"{
            d_me["load_single"]=d_cmp["sd_cmp_id"]
            let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["sd_cmp_id"]!+"/7/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
        }
        
        
        if d_me["sd_user_id"] == nil {
            //get the user channel from the local database
            let context = persistentContainer.viewContext
            let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request1.returnsObjectsAsFaults = false

            do {
                let result = try context.fetch(request1)
                for data in result as! [NSManagedObject] {
                    d_me["sd_user_id"] = data.value(forKey: "channel") as? String
                    d_me["audio"] = data.value(forKey: "audio") as? String
                }
            } catch {
            }
        }
        if d_me["sd_latitude"] == nil {
            determineMyCurrentLocation()
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
    
                if Reachability.isConnectedToNetwork() &&  d_me["sd_user_id"] != nil && d_me["sd_latitude"] != nil {
                    
                    d_me["mode"] = "adds"
                    
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
                            
                            if d_me["single"] == "0" {
                                d_oth["update"] = "yes"
                                let rootViewController = self.window!.rootViewController as! UINavigationController
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let targerView = mainStoryboard.instantiateViewController(withIdentifier: "myDashboard")
                                rootViewController.pushViewController(targerView, animated: false)
                                
                            } else {
                                let rootViewController = self.window!.rootViewController as! UINavigationController
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let targerView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
                                rootViewController.pushViewController(targerView, animated: false)
                            }
                           
                        }
                    }
                } else {
                    //no network or touched notification when app was killed.
                    let rootViewController = self.window!.rootViewController as! UINavigationController
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let targerView = mainStoryboard.instantiateViewController(withIdentifier: "myDashboard")
                    rootViewController.pushViewController(targerView, animated: false)
                }
                
                d_cmp["single"] = d_me["single"]
                let urlString1:String = "http://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp["single"]!+"/1/0"
                var myrequest = URLRequest(url: URL(string:urlString1)!)
                myrequest.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                    guard let _ = data, error == nil else {
                        return
                    }
                }
                task.resume()
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {
        
//        let rootViewController = self.window!.rootViewController as! UINavigationController
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let targerView = mainStoryboard.instantiateViewController(withIdentifier: "myDashboard")
//        rootViewController.pushViewController(targerView, animated: false)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {

        determineMyCurrentLocation()
        d_oth["update"] = "yes"
        d_me["mode"] = "near"
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
         d_oth["update"] = "yes"
    }
    func applicationWillTerminate(_ application: UIApplication) {self.saveContext()}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Soundrops")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        return handled
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        d_me["sd_latitude"] = String(userLocation.coordinate.latitude)
        d_me["sd_longitude"] = String(userLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
    }
}

extension  AppDelegate: UNUserNotificationCenterDelegate {

//    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        if Bool(d_me["audio"]!)! {
//            completionHandler([.alert,.sound])
//        } else {
//            completionHandler([.alert])
//        }
//    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
