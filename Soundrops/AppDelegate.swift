import UIKit
import AuthenticationServices
import CoreData
import UserNotifications
import PushNotifications
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import Alamofire
import SystemConfiguration
import Network
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate  {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       window?.overrideUserInterfaceStyle = .light
        isConnectedtoWifi = c_wifi.isWiFiConnected()
        

        
        c_wifi.getLocation()

        handleKeyChain()
        if myuser.userprofile == 1 {
           
        }
        // opened from a push notification when the app is closed
        if launchOptions != nil{
            let notificationPayload: NSDictionary  = launchOptions! as NSDictionary
            if notificationPayload["UIApplicationLaunchOptionsRemoteNotificationKey"] != nil {
              let mydict: NSDictionary = notificationPayload["UIApplicationLaunchOptionsRemoteNotificationKey"]! as! NSDictionary
              let mydict1: NSDictionary = mydict["data"]! as! NSDictionary
              for (key,value) in mydict1 {
                  let mykey = key as! String
                  if mykey == "campaign-id" {
                      notificationCampaign = value as! Int
                  }
              }
            }
        }
        
        //pushnotifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized:Bool,error:Error?) in
            if authorized {Notification_granted = true}
        }
        self.pushNotifications.start(instanceId: "01951d5b-82d4-4b3c-a9d1-dca0353072fd")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: userChannel)
        //google login
        GIDSignIn.sharedInstance()?.clientID = "2478859469-lres65uhil6ca8vs52gq2os3ddd9f0pr.apps.googleusercontent.com"
        GMSServices.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        GMSPlacesClient.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        
        //actions
        let details = UNNotificationAction(identifier: "details",
                                              title: "Details",
                                              options: [.foreground])
        let follow = UNNotificationAction(identifier: "follow",
                                            title: "Follow",
                                            
                                            //old answertwo
                                            options: [.foreground])
        let website = UNNotificationAction(identifier: "website",
                                             title: "Go to Website",
                                             options: [.foreground])
        
          
        // categories
        let community = UNNotificationCategory(identifier: "community",
                                                actions: [],
                                                intentIdentifiers: [],
                                                options: [])
        let all = UNNotificationCategory(identifier: "optionCategory",
                                                 actions: [website, details, follow],
                                                 intentIdentifiers: [],
                                                 options: [])
        UNUserNotificationCenter.current().setNotificationCategories( [community,all])
        application.registerForRemoteNotifications()
        return true
    }
    
  //  @available(iOS 9.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //this method is only called when the app is in the foreground
        c_api.patchrequest(company: String(cmpId), key: "stat", action: "10") {
        }
        completionHandler([.banner, .badge, .sound])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did not register")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //share data
        let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
        defaults?.synchronize()
        let action = response.actionIdentifier
        let request = response.notification.request
        if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
            //print("data",PusherNotificationData)
            cmpId  = PusherNotificationData["campaign-id"] as! Int
        }
        c_api.patchrequest(company: String(cmpId), key: "stat", action: "18") {
        }
        if action == "follow" {
            c_api.patchrequest(company: String(cmpId), key: "following", action: "") {
            }
            c_api.patchrequest(company: String(cmpId), key: "stat", action: "11") {
            }
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targetView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
            rootViewController.pushViewController(targetView, animated: false)
        }

        if action == "website"{
            c_api.patchrequest(company: String(cmpId), key: "stat", action: "13") {
            }
            if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
                if let siteData = PusherNotificationData["site-url"] as? String {
                    if let url = URL(string: siteData) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }
        if action == "details"{
            c_api.patchrequest(company: String(cmpId), key: "stat", action: "1") {
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let targetView = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController")
                rootViewController.pushViewController(targetView, animated: false)
            }
        }
        loadinfo_local()
    }
    
    func loadinfo_local() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            if Reachability.isConnectedToNetwork() &&  userChannel != "" && myuser.userlat > 0 {
                g_mod = "myads"
            } else {
                //no network or touched notification when app was killed.
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let targerView = mainStoryboard.instantiateViewController(withIdentifier: "myDashboard")
                rootViewController.pushViewController(targerView, animated: false)
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

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        try? self.pushNotifications.addDeviceInterest(interest: userChannel)
        
        let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
        defaults?.synchronize()

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification
       userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let aps = userInfo["aps"] as? [String: Any], let _ = aps["badge"] as? Int {
                // Increment the app's badge counter
           //     application.applicationIconBadgeNumber += badgeCount
                UIApplication.shared.applicationIconBadgeNumber = application.applicationIconBadgeNumber
        }
        
        if let data = userInfo["data"] as? [String: Any],
           let compid = data["compid"] {
            cmpId = compid as! Int
        }
        c_api.patchrequest(company: String(cmpId), key: "stat", action: "10") {
        }
        
        let params = "/"+userChannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
        c_api.getrequest(params: params, key: "getuser") {
            if let index = myAds?.firstIndex(where: { $0.id == cmpId }) {
                    cmpId = index
            }
        }
        cmptype = "myads"

       // application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
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
            print("Error")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)

    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        c_api.patchrequest(company: "0", key: "stat", action: "17") {}
        
        try? self.pushNotifications.addDeviceInterest(interest: userChannel)
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

    func handleKeyChain() {
        
        //create 3 values for storage in keychain
        if KeychainSwift().get("channel") != nil {
            userChannel  = KeychainSwift().get("channel")!
            if let prof = KeychainSwift().get("profile") {
                myuser.userprofile = Int(prof)!
            }
            userAudio = (KeychainSwift().get("audio") != nil)
            if let storedUsername = KeychainSwift().get("name") {
                myuser.username = storedUsername
            }
        } else {
            let millisecondsSince1970 = Int64(Date().timeIntervalSince1970 * 1000)
            let millisecondsString = String(millisecondsSince1970)
            let channel = randomAlphaNumericString(length: 10)+millisecondsString
            KeychainSwift().set(channel, forKey: "channel")
            KeychainSwift().set("0", forKey: "profile")
            KeychainSwift().set(true, forKey: "audio")
        }
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
