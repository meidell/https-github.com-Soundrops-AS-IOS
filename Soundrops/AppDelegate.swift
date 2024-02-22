import UIKit
import AuthenticationServices
import CoreData
import PushNotifications
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import Alamofire
import SystemConfiguration
import Network
import Foundation
import Security
import KeychainSwift

var touched: String = "no"

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate  {
    
    var window: UIWindow?
    let beamsClient = PushNotifications.shared
    var notifications = [String: String]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let notification = launchOptions?[.remoteNotification] {
            touched = "yes"
        } else {
            touched = "no"
        }
        
        //google login
             GIDSignIn.sharedInstance()?.clientID = "2478859469-lres65uhil6ca8vs52gq2os3ddd9f0pr.apps.googleusercontent.com"
             GMSServices.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
             GMSPlacesClient.provideAPIKey("AIzaSyCvsTZwk0QIhkkte8z7hIMv_1X5puz4cz4")
        
                
        UNUserNotificationCenter.current().delegate = self
        window?.overrideUserInterfaceStyle = .light
        c_wifi.isWiFiConnected()
        c_wifi.checkandGetLocation()
    
        
        if KeychainSwift().get("channel") != nil {
            
            userChannel = KeychainSwift().get("channel")!
            
            application.registerForRemoteNotifications()
            self.beamsClient.start(instanceId: "01951d5b-82d4-4b3c-a9d1-dca0353072fd")
            self.beamsClient.registerForRemoteNotifications()
            do {
                try self.beamsClient.addDeviceInterest(interest: userChannel)
            } catch {
            }

            //actions
            let details = UNNotificationAction(identifier: "details",
                                                  title: "Kampanje",
                                                  options: [.foreground])
            let follow = UNNotificationAction(identifier: "follow",
                                                title: "Følg",
                                                options: [.foreground])
            let website = UNNotificationAction(identifier: "website",
                                                 title: "Nettsted",
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
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //this method is only called when the app is in the foreground
        completionHandler([.banner, .badge, .sound])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.beamsClient.registerDeviceToken(deviceToken) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
               let token = tokenParts.joined()
            print("Device Token: \(token)")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to APN")
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
        //share data
        var sent: Bool = false
        let defaults = UserDefaults(suiteName: "group.soundropsios")
        defaults?.synchronize()
        let action = response.actionIdentifier
        let request = response.notification.request
        if request.content.userInfo["data"] is NSDictionary {
            if let data = request.content.userInfo["data"] as? [String: Any],
               let compid = data["campaign-id"] {
                cmpId = compid as! Int
            }
        }
        
        cmptype = "notification"
        NotificationReceived = "yes"
        startedWithNotification = "yes"

        let userchannel = userChannel
        let params = "/"+userchannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
        
            if action == "follow" {
                c_api.patchrequest(company: String(cmpId), key: "following", action: "") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let rootViewController = self.window!.rootViewController as! UINavigationController
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let targetView = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
                        rootViewController.pushViewController(targetView, animated: false)
                    }
                   
                }
                sent = true
                c_api.patchrequest(company: String(cmpId), key: "stat", action: "11") {
                }
            }

            if action == "website"{
                sent = true
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
            if action == "details" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let rootViewController = self.window!.rootViewController as! UINavigationController
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let targetView = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
                        rootViewController.pushViewController(targetView, animated: false)
                    }
                }
            }
            // Additional code for handling whether the notification was opened
           if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
               if touched == "no" {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       let rootViewController = self.window!.rootViewController as! UINavigationController
                       let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       let targetView = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
                       rootViewController.pushViewController(targetView, animated: false)
                   }
                  // touched = "yes"
               }
           }
            if sent == false {
                c_api.patchrequest(company: String(cmpId), key: "stat", action: "1") {
                }
            }
           
        
        let notificationId = response.notification.request.identifier
        if notifications[notificationId] != nil {
            notifications.removeValue(forKey: notificationId)
        }
    
        c_wifi.isWiFiConnected()
        completionHandler()
    }
     
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        try? self.beamsClient.addDeviceInterest(interest: userChannel)
        let defaults = UserDefaults(suiteName: "group.soundropsios")
        defaults?.synchronize()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification
       userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if KeychainSwift().get("channel") != nil  {
            userChannel  = KeychainSwift().get("channel")!
            if let aps = userInfo["aps"] as? [String: Any] {
                if aps["alert"] is [String: Any] {
                    if let data = userInfo["data"] as? [String: Any] {
                       if let compid = data["campaign-id"] {
                           cmpId = compid as! Int
                           if cmpId > 0 {
                               cmptype = "notification"
                               application.applicationIconBadgeNumber += badgeCount
                               UIApplication.shared.applicationIconBadgeNumber = application.applicationIconBadgeNumber
                           }
                       }
                   }
                } else {
                    guard let url2 = URL(string: "https://appservice1.share50.no/silentpush/update") else { return }
                    var request2 = URLRequest(url: url2)
                    request2.httpMethod = "POST"
                    request2.setValue("androidios", forHTTPHeaderField: "authorization")
                    request2.setValue("greatballsoffire", forHTTPHeaderField: "password")
                    request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request2.setValue(userChannel, forHTTPHeaderField: "channel")
                    let task = URLSession.shared.dataTask(with: request2) { data, response, error in
                        if let error = error {
                            return
                        }
                    }
                    task.resume()
                }
                
            } else {
            }
        }
        completionHandler(.newData)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        var mytest: Bool = false
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            if isConnectedtoNotifications {mytest = true}
            
            
            switch settings.authorizationStatus {
                case .authorized:
                    isConnectedtoNotifications = true
                case .denied:
                    isConnectedtoNotifications = false
                case .notDetermined:
                    isConnectedtoNotifications = false
                case .provisional:
                    isConnectedtoNotifications = false
                case .ephemeral:
                    isConnectedtoNotifications = false
                @unknown default:
                    break
            }
                        
            if mytest && !isConnectedtoNotifications {showWarning = true}
            if !isConnectedtoNotifications  {
                c_api.patchrequest(company: "", key: "notifications-off", action: "") {}
            } else {
                c_api.patchrequest(company: "", key: "notifications-on", action: "") {}
            }
            
            if !isConnectedtoNotifications {
            }
        }
    }
}

extension  AppDelegate: UNUserNotificationCenterDelegate {
}
