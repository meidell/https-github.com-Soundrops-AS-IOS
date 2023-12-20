import UIKit
import AuthenticationServices
import CoreData
import UserNotifications
import PushNotifications
import GoogleMaps
import GooglePlaces
import Alamofire
import SystemConfiguration


// perks
struct Perk {
    var id: String
    var logo: String
    var mainImage: String
    var company: String
    var mydescription: String
    var outlets: String
    var disclaimer: String
    var title: String
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["_id"] as? String ?? ""
        self.logo = dictionary["Logo"] as? String ?? ""
        self.mainImage = dictionary["Img"] as? String ?? ""
        self.company = dictionary["Company"] as? String ?? ""
        self.mydescription = dictionary["Desc"] as? String ?? ""
        self.outlets = dictionary["Desc_outlets"] as? String ?? ""
        self.disclaimer = dictionary["Desc_disclaimer"] as? String ?? ""
        self.title = dictionary["Perk_name"] as? String ?? ""
    }
}
var perkList = [Perk]()

// Organisations
struct Organisation {
    var orgid: Int
    var orgname: String
    init(_ dictionary: [String: Any]) {
        self.orgid = dictionary["orgid"] as? Int ?? 0
        self.orgname = dictionary["orgname"] as? String ?? ""
    }
}
var organiationList = [Organisation]()

// campaign details
var d_cmp = [String: String]()
// lists for tables
var d_lst = [String: String]()
// personal info
var d_me = [String: String]()
// other stuff
var d_oth = [String: String]()
var saidLater: Bool = false
// modes
var g_mod: String = "adds"
var g_omd: String = ""
var g_curr: Int = 0
var g_NumCategories: Int = 0
var Notification_granted: Bool = false
var received_first_notification: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate, CLLocationManagerDelegate  {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    var locationManager:CLLocationManager!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("start1")
        getUserChannel()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) async -> Bool {
        
        d_oth["update"] = "no"
        d_me["sd_longitude"]="55"
        d_me["sd_latitude"]="6"
        d_me["notifications"]="1"
        d_me["sd_accept"]="false"
        d_me["sd_user_active"]="false"
        d_me["sd_org_change"]="false"
        d_me["hometown"]=""
        
        print("start2")
        if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
        
        if launchOptions != nil{
            // opened from a push notification when the app is closed
            let notificationPayload: NSDictionary  = launchOptions! as NSDictionary
            if notificationPayload["UIApplicationLaunchOptionsRemoteNotificationKey"] != nil {
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
        }
        getUserChannel()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized:Bool,error:Error?) in
       
            if authorized {
                Notification_granted = true
            }
        }
        
        //pushnotifications
        self.pushNotifications.start(instanceId: "01951d5b-82d4-4b3c-a9d1-dca0353072fd")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: d_me["sd_user_id"]!)
        
        GMSServices.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        GMSPlacesClient.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
          
        //community
        let community = UNNotificationCategory(identifier: "community",
                                                actions: [],
                                                intentIdentifiers: [],
                                                options: [])
        
        let cmpdetails = UNNotificationAction(identifier: "cmpdetails",
                                              title: "Details",
                                              options: [.foreground])
        
        
        let followMe = UNNotificationAction(identifier: "followMe",
                                            title: "Follow",
                                            options: [.foreground])
        
        //nocall
        let noCategory = UNNotificationCategory(identifier: "noCategory",
                                                 actions: [cmpdetails, followMe],
                                                 intentIdentifiers: [],
                                                 options: [])
        
        let myNotification = UNNotificationCategory(identifier: "myNotification",
                                                    actions: [followMe],
                                                    intentIdentifiers: [],
                                                    options: [])
        
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
                                             title: "Go to Website",
                                             options: [.foreground])
        
        let twoCategory = UNNotificationCategory(identifier: "twoCategory",
                                                 actions: [answerTwo, cmpdetails, followMe],
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
        
        //
        UNUserNotificationCenter.current().setNotificationCategories( [community,noCategory,oneCategory,twoCategory,threeCategory,fourCategory, myNotification])
        application.registerForRemoteNotifications()
        return true
    }
    
    @available(iOS 9.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //this method is only called when the app is in the foreground
        print("start3")
        if d_me["audio"] == nil {d_me["audio"] = "true"}
        if d_me["audio"]! == "true" {
             completionHandler([[.list, .banner], .badge, .sound])
        } else {
            completionHandler([[.list, .banner], .badge])
        }
        completionHandler([[.list, .banner], .badge, .sound])
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
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //alert here
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //share data
        let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
        defaults?.synchronize()

        
        let action = response.actionIdentifier
        let request = response.notification.request
        if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
            d_me["single"]  = String(PusherNotificationData["campaign-id"] as! Int)
            d_me["compid"]  = String(PusherNotificationData["compid"] as! Int)
            if String(PusherNotificationData["mytitle"] as! String) == "Soundrops Community" {
                d_me["single"] = "0"
            }
        }
        
        d_cmp["adds:update"] = "yes"

        if action == "answerOne"{
        }
        
        if action == "followMe" {
            
            d_cmp[d_me["single"]!+":sd_following"] = "true"
            
            let url = "https://webservice.soundrops.com/REST_set_unset_following/"+d_me["sd_user_id"]!+"/"+d_me["compid"]!+"/1"
            var request = URLRequest(url: URL(string:url)!)
            request.httpMethod = "GET"
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            request.setValue("Authorization", forHTTPHeaderField: "")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard data != nil else {return}
            }
            task.resume()
            
        }

        if action == "answerTwo"{
            SaveStats.postStats(cmp_id: Int(d_cmp["sd_cmp_id"]!)!, cmp_action: 3)
            if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
                if let siteData = PusherNotificationData["site-url"] as? String {
                    if let url = URL(string: siteData) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }
        
        if action == "answerThree"{
            SaveStats.postStats(cmp_id: Int(d_cmp["sd_cmp_id"]!)!, cmp_action: 5)
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targerView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
            rootViewController.pushViewController(targerView, animated: false)
        }

        if action == "answerFour"{
            SaveStats.postStats(cmp_id: Int(d_cmp["sd_cmp_id"]!)!, cmp_action: 7)
        }

        if action == "answerFive"{
            d_me["load_single"]=d_cmp["sd_cmp_id"]
            SaveStats.postStats(cmp_id: Int(d_cmp["sd_cmp_id"]!)!, cmp_action: 7)

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
            loadinfo_local()
        }
    }
    
    func loadinfo_local() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {

            if Reachability.isConnectedToNetwork() &&  d_me["sd_user_id"] != nil && d_me["sd_latitude"] != nil {
                LoadInfo.loadCampaign()
                
            } else {
                //no network or touched notification when app was killed.
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let targerView = mainStoryboard.instantiateViewController(withIdentifier: "myDashboard")
                rootViewController.pushViewController(targerView, animated: false)
            }
            
            d_cmp["single"] = d_me["single"]
            SaveStats.postStats(cmp_id: Int(d_cmp["single"]!)!, cmp_action: 1)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("start4")
        
        try? self.pushNotifications.addDeviceInterest(interest: d_me["sd_user_id"]!)
        
        let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
        defaults?.synchronize()
   //     if let restoredValue = defaults!.string(forKey: "alarmTime") {
   //     }
        determineMyCurrentLocation()
        d_oth["update"] = "yes"
        d_me["mode"] = "near"
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification
       userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        let state = application.applicationState
        switch state {

        case .inactive:
            print("Inactive")

        case .background:
            print("Background")
            // update badge count here
           
        case .active:
            print("Active")
            
        @unknown default:
            print("default")
        }

    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
      print("start5")
        try? self.pushNotifications.addDeviceInterest(interest: d_me["sd_user_id"]!)
        let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
        defaults?.synchronize()
        if let restoredValue = defaults!.string(forKey: "alarmTime")  {
            if received_first_notification == true {
                d_cmp["single"]  = restoredValue
                 loadinfo_local()
            }
            received_first_notification = true
        }
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
    
    func getUserChannel() {
        var count: Int = 0
        var i: Int = 0
        let context = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        i = 0
        do { count = try context.count(for: request) }
        catch {}
        
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
            }
            catch {}
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
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targerView = mainStoryboard.instantiateViewController(withIdentifier: "Learning1")
            rootViewController.pushViewController(targerView, animated: false)
        }
        
        i = 0
        print("here")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                d_me["sd_user_id"] = data.value(forKey: "channel") as? String
                print("me", d_me["sd_user_id"])
                d_me["audio"] = data.value(forKey: "audio") as? String
            }
        } catch {
        }
    }
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
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
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
