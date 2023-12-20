//
//  RestApi.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 18.01.23.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import PushNotifications
import UIKit
import CoreData


class restAPI {
    
    var window: UIWindow?
    
    class func saveUser() {
        
        lazy var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "Soundrops")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        //get the user channel from the local database
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(userChannel, forKey: "channel")
                data.setValue(d_me["audio"]!, forKey: "audio")
                do {
                    try context.save()
                } catch {
                }
            }
        } catch {
        }
        //get user data from server
        d_me["new"]="1"
    }
    
    class func deletetUser() -> String? {
        
        var responseString: String?
            var request = URLRequest(url: URL(string: "https://webservice.soundrops.com/discontinueuser")!)
            let json: [String: Any] = [
                "channel": userChannel,
                "logontype": "appleauto"
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    responseString = String(data: data, encoding: .utf8)
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String: Any] {
                        responseString = json["user"] as? String
                    }
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            return responseString
    }
    
    class func postUser() -> String? {
        var responseString: String?
            var request = URLRequest(url: URL(string: "https://webservice.soundrops.com/setappleuser")!)
            let json: [String: Any] = [
                   "channel": userChannel,
                   "notific": Int(d_me["notifications"]!)!,
                   "id_token": d_me["token"]!,
                   "name": d_me["sd_name"]!
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    responseString = String(data: data, encoding: .utf8)
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String: Any] {
                        let channel = json["channel_overwrite"] as! String
                        if channel != "added" {
                            responseString = "old"
                            userChannel = channel
                           let pushNotifications = PushNotifications.shared
                            try? pushNotifications.addDeviceInterest(interest: userChannel)
                        } else {
                            responseString = "new"
                        }
                    }
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            return responseString
       
    }
    
    class func postNewUser(completion: @escaping (Bool)->() ) {
        
        if noNet == false {
            var request = URLRequest(url: URL(string: "https://webservice.soundrops.com/setappleuser")!)
            let json: [String: Any] = [
                   "channel": userChannel,
                   "notific": Int(d_me["notifications"]!)!,
                   "id_token": d_me["token"]!,
                   "name": d_me["sd_name"]!
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let dataResponse = data, error == nil else {
                    return
                }
                do{
                    let jsonResponse = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
                    if let jsonResponse = jsonResponse as? [String: Any] {
                        let channel = jsonResponse["channel_overwrite"] as! String
                        if channel != "added" {
                            completion(false)
                            userChannel = channel
                            
                            let pushNotifications = PushNotifications.shared
                            try? pushNotifications.addDeviceInterest(interest: userChannel)
                            restAPI.saveUser()
                        } else {
                            completion(false)
                            restAPI.saveUser()
                        }
                    }
                }
            }
            task.resume()
        }
        
       
    }
    
    class func postUpdateUser() {
        
        if noNet == false {

            if d_me["sd_login_method"] == nil || d_me["sd_login_method"] == "" {d_me["sd_login_method"] = "sd"}
            let replaced = d_me["sd_name"]!.replacingOccurrences(of: " ", with: "_")
            if d_me["sd_login_method_id"] == nil || d_me["sd_login_method_id"] == "" {d_me["sd_login_method_id"] = "0"}
            if d_me["longitude"] == nil {d_me["longitude"] = "0.00"}
            if d_me["latitude"] == nil {d_me["latitude"] = "0.00"}

            let json: [String: Any] = [
               "userchannel": userChannel,
               "username": replaced,
               "userage": d_me["sd_age"]!,
               "userlong": d_me["longitude"]!,
               "userlat": d_me["latitude"]!,
               "usergender": d_me["sd_gender"]!,
               "userhometown" :  d_me["hometown"]!,
               "org": d_me["sd_org_id"]!
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            var request = URLRequest(url: URL(string: "https://webservice.soundrops.com/userupdate")!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
            }
            task.resume()
                }
    }
    
  
    
    class func loadImages() {
        
        var j = 0
        while j <= 5 {
            j += 1
            Alamofire.request(d_cmp[String(j)+":sd_company_logo"] ?? "").responseImage { response in
                let image = response.result.value
                DispatchQueue.main.async {
                    let fileManager = FileManager.default
                    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(String(j)+".sd_company_logo.jpg")
                    let imageData = image?.jpegData(compressionQuality: 0.5);
                    fileManager.createFile(atPath: imagePath as String, contents: imageData, attributes: nil)
                    d_cmp[String(j)+"sd_company_logo"] = String(imagePath)
                }
            }
        }
    }
    
    
    class func getUser() -> String? {
        
        var responseString: String?

        if noNet == false {
            newUser=true
            let url = URL(string: "https://webservice.soundrops.com/REST_get_user_data/"+userChannel)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    responseString = String(data: data, encoding: .utf8)
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String: Any] {
                        let json = json["data_result"] as! NSDictionary
                        d_me["sd_name"] = String(json["username"] as! String)
                        d_me["sd_age"] = String(json["userage"] as! Int)
                        d_me["sd_gender"] = String(json["usergender"] as! Int)
                        d_me["sd_accept"] = String(json["useraccept"] as! Int)
                        d_me["sd_audio"] = String(json["useraudio"] as! Bool)
                        d_me["sd_org_id"] = String(json["userorg"] as! Int)
                        d_me["sd_org_name"] = String(json["orgname"] as! String)
                        d_me["sponsorlogo"] = String(json["sponsorlogo"] as! String)
                        d_me["hometown"] = String(json["hometown"] as! String)
                        d_me["sd_org_description"] = String(json["orgdesc"] as! String)
                        d_me["sd_org_image_logo"] = String(json["orgimagelogo"] as! String)
                        d_me["sd_org_image"] = String(json["orgimage"] as! String)
                        d_me["sd_org_number_followers"] = String(json["orgfollowers"] as! String)
                        d_me["sd_org_funds_raised"] = String(json["orgfundsraised"]! as! Double)
                        d_me["sd_user_active"] = String(json["useractive"]! as! Bool)
                        d_me["installcomplete"] = String(json["installcomplete"]! as! Bool)                        
                        responseString = String(json["sponsorlogo"] as! String)
                        newUser=false
                    }
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        } else {
            responseString=""
        }
        
        return responseString
    }
    
    class func getUserData() {
        
        if noNet == false {
            let myurl: String  = "https://webservice.soundrops.com/REST_get_user_data/"+userChannel
            let headers = [
                  "auth_user": "user",
                  "auth_pass": "pass"
              ]
            Alamofire.request(myurl, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    let JSON = json as! NSDictionary
                    if JSON["data_result"] != nil {
                        let JSON1 = JSON["data_result"] as! NSDictionary
                        d_me["sd_name"] = String(JSON1["username"] as! String)
                        d_me["sd_age"] = String(JSON1["userage"] as! Int)
                        d_me["sd_gender"] = String(JSON1["usergender"] as! Int)
                        d_me["sd_accept"] = String(JSON1["useraccept"] as! Int)
                        d_me["sd_audio"] = String(JSON1["useraudio"] as! Bool)
                        d_me["sd_org_id"] = String(JSON1["userorg"] as! Int)
                        d_me["sd_org_name"] = String(JSON1["orgname"] as! String)
                        d_me["sponsorlogo"] = String(JSON1["sponsorlogo"] as! String)
                        d_me["hometown"] = String(JSON1["hometown"] as! String)
                        d_me["sd_org_id"] = String(JSON1["orgid"] as! Int)
                        d_me["sd_org_description"] = String(JSON1["orgdesc"] as! String)
                        d_me["sd_org_image_logo"] = String(JSON1["orgimagelogo"] as! String)
                        d_me["sd_org_image"] = String(JSON1["orgimage"] as! String)
                        d_me["sd_org_number_followers"] = String(JSON1["orgfollowers"] as! String)
                        d_me["sd_org_funds_raised"] = String(JSON1["orgfundsraised"]! as! Double)
                        d_me["sd_user_active"] = String(JSON1["useractive"]! as! Bool)
                        d_me["installcomplete"] = String(JSON1["installcomplete"]! as! Bool)
                    }
                }
            }
            
        }
        
       
    }
    
    class func getOrganisations(url:String) {
        
        if noNet == false {
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            request.setValue("user", forHTTPHeaderField: "auth_user")
            request.setValue("pass", forHTTPHeaderField: "auth_pass")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let dataResponse = data, error == nil else {
                    return
                }
                do{
                    let jsonResponse = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
                    if let jsonResponse = jsonResponse as? [String: Any] {
                        var i: Int = 0
                        for (_, content) in jsonResponse {
                            let value = content as! NSDictionary
                            i+=1
                            d_me[String(i)+":sd_org_name"] = value["orgname"] as? String
                            d_me[String(i)+":sd_org_id"] = String(value["orgid"] as! Int)
                            d_me["count"]=String(i)

                        }
                    }
                }
            }
            
            task.resume()
        }
        
    }
            
     
