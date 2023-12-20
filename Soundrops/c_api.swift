//
//  Share50API.swift
//  Soundrops
//
//  Created by JEM on 13.11.2023.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
// test

import Foundation
import Alamofire
import AlamofireImage
import PushNotifications
import UIKit
import CoreData
import KeychainSwift

// campaign details
var notificationCampaign:  Int = 0
var d_cmp = [String: String]()
var d_lst = [String: String]()
var d_me = [String: String]()
var myCategory = [String: Int]()
var saidLater: Bool = false
var isConnectedtoWifi: Bool = false

// modes
var g_mod: String = "adds"
var g_omd: String = ""
var g_curr: Int = 0
var Notification_granted: Bool = false
var newUser: Bool = false
var received_first_notification: Bool = false
var g_NumCategories: Int = 0
var campID: Int = 0


struct adcategory: Codable {
    let originalid: Int
    let name: String
}

var adcategories: [adcategory]?

struct AdOutlet: Codable {
    let lat: Double?
    let lon: Double?
    let name: String?
    let address: String?
    let distance: Double?
}

struct perk: Codable {
    let perkid: Int
    let perkcompany: String?
    let perkname: String?
    let perkurl: String?
    let perkdescription: String?
    let perkoutlets: String?
    let perkdisclaimer: String?
    let perkimg: String?
    let perklogo: String?
}
var perks: [perk]?

struct ads: Codable {
    let id: Int
    let headline: String?
    let message: String?
    let calltoaction: Int?
    let calltoactionresource: String?
    let outlets: [AdOutlet]?
    let logo: String?
    let companyname: String?
    let companyid: Int?
    let image: String?
    let exclusive: Int?
    let adcategory: Int?
    let video: String?
    var following: Int?
}
var myAds: [ads]?
var nearbyAds: [ads]?

struct user: Codable {
    var username: String = ""
    var userorg: Int = 0
    var usergender: Int = 0
    var userage: Int = 0
    var useraccept: Int?
    var userlon: Double = 5.555
    var userlat: Double = 58.888
    var userprofile: Int = 0
    var userhometown: String = ""
    var userpostcode: String = ""
    var userpicture: String?
}
var myuser = user()
var userpostlon: Double = 5.555
var userpostlat: Double = 58.888

struct org: Codable {
    var orgname: String = ""
    var orglogo: String = ""
    var orgid: Int = 0
    var orgrevenue: Int = 0
    var orgfollowers: Int = 0
}
var myorg = org()

struct WSYC: Codable {
    let companyname: String
    let logostream: String
    let slogan: String
}
var wsyc: WSYC?

struct mainimage: Codable {
    let id: Int
    let image: String
}
var mainimages: [mainimage]?

struct Community: Codable {
    let id: Int
    let heading: String
    let story: String
    let imagestream: String
}
var communities: [Community]?

struct ResponseData: Codable {
    let myads: [ads]
    let user: user
    let org: org
    let nearby: [ads]
    let wsyc: WSYC
    let community: [Community]
}

struct postcode: Codable {
    let place: String
    let lat: Double
    let lon: Double
}

struct Organisation: Codable {
    let orgname: String?
    let orglogo: String?
    let orgid: Int?
    let orgrevenue: Int?
    let orgfollowers: Int?
}
var Organisations: [Organisation]?

var sortedCategoryList: [(key: String, value: Int)] = []

//user data
var userCountry = ""
var userPicture = ""
var userToken = ""
var userChannel = ""
var userAudio = true
var userNotification = ""
var userDataSet = false
var userAccept = false
var cmpId = 0
var cmpHeadline = ""
var cmptype = ""
var perkId = 0
var mainImageCounter = 0
var userCategory = 0

class c_api {
    
    class func geturls(key: String) -> String? {
        
        var urls = [String: String]()
        urls["getpostcode"] = "https://appservice.share50.no/postcode"
        urls["getuser"] = "https://appservice.share50.no/user"
        urls["getperk"] = "https://appservice.share50.no/perks/all"
        urls["getmainimages"] = "https://appservice.share50.no/mainimages"
        urls["updateuser"] = "https://appservice.share50.no/updateuser"
        urls["setappleuser"] = "https://appservice.share50.no/setappleuser"
        urls["getorganisations"] = "https://appservice.share50.no/organisations"
        urls["getadcategories"]  = "https://appservice.share50.no/adcategory/get"
        urls["following"]  = "https://appservice.share50.no/following"
        urls["stat"]  = "https://statservice.share50.no/stats/track"
        urls["discontinue"]  = "https://appservice.share50.no/discontinueuser"
        
        return urls[key]
    }
    
    class func deleterequest(channel: String, completion: @escaping (Bool) -> Void) {
        
        let urlString = geturls(key: "discontinue")!
        print("delete ",channel)
        
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("androidios", forHTTPHeaderField: "authorization")
            request.setValue("greatballsoffire", forHTTPHeaderField: "password")
            request.setValue(channel, forHTTPHeaderField: "channel")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false) // Call the completion handler with false if there's an error
                    return
                }
                
                let httpResponse = response as? HTTPURLResponse
                
                if httpResponse!.statusCode == 200 {
                    completion(true) // Call the completion handler with true for success
                } else {
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                    completion(false) // Call the completion handler with false for non-200 status code
                }
            }
            
            task.resume()
        }
    }

    
    
        
    class func patchrequest(company: String, key: String, action: String, completion: @escaping () -> Void) {
        
         let urlString = geturls(key: key)!
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("androidios", forHTTPHeaderField: "authorization")
            request.setValue("greatballsoffire", forHTTPHeaderField: "password")
            request.setValue(userChannel, forHTTPHeaderField: "channel")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var jsonData: [String: Any] = [:]
            
            if key == "following" {
                jsonData["company"] = company
            }
            if key == "stat" {
                jsonData["lat"] = String(myuser.userlat)
                jsonData["lng"] = String(myuser.userlon)
                jsonData["channelid"] = userChannel
                jsonData["cmpid"] = company
                jsonData["action"] = action
            }
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData) {
                request.httpBody = jsonData
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                let httpResponse = response as? HTTPURLResponse

                if httpResponse!.statusCode == 200 {
                    if key == "following" {
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
                    }
                } else {
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                }
                completion()
            }
            task.resume()
        }
    }
    
    class func postrequest(params: String, key: String, completion: @escaping () -> Void) {
        
        let urlString = geturls(key: key)! + params
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("androidios", forHTTPHeaderField: "authorization")
            request.setValue("greatballsoffire", forHTTPHeaderField: "password")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var jsonData: [String: Any] = [:]
            
            if key == "setappleuser" {
                
                jsonData["id_token"] = userToken
                jsonData["channel"] = userChannel
                jsonData["notification"] = 1
                jsonData["name"] = myuser.username
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData) {
                    request.httpBody = jsonData
                }
            }
            
            if key == "updateuser" {
                jsonData["userchannel"] = userChannel
                jsonData["userlat"] = String(userpostlat)
                jsonData["userlong"] = String(userpostlon)
                jsonData["userage"] = String(myuser.userage)
                jsonData["org"] = String(myuser.userorg)
                jsonData["usergender"] = String(myuser.usergender)
                jsonData["usercountry"] = "NO"
                jsonData["username"] = myuser.username
                jsonData["userhometown"] = myuser.userhometown
                jsonData["userpostcode"] = myuser.userpostcode
                jsonData["notifications"] = "1"
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData) {
                    request.httpBody = jsonData
                }
            }
           
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                let httpResponse = response as? HTTPURLResponse

                if httpResponse!.statusCode == 200 {
                    if key == "updateuser" {
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
                        if jsonResponse is [String: Any] {
                            KeychainSwift().set("1", forKey: "profile")
                            KeychainSwift().set(myuser.username, forKey: "name")
                        }
                    }
                } else {
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                    myuser.userprofile=0
                }
                completion()
            }
            task.resume()
        }
    }
    
    class func getrequest(params: String, key: String, completion: @escaping () -> Void) {
        
        //endstring parameters
        let urlString = geturls(key: key)! + params
        print(urlString)
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("androidios", forHTTPHeaderField: "authorization")
            request.setValue("greatballsoffire", forHTTPHeaderField: "password")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                let httpResponse = response as? HTTPURLResponse
                if httpResponse!.statusCode == 200 {
                    guard let data = data else {
                        //no data received
                        return
                    }
                    do {
                        if key == "getadcategories" {
                            let adcategories = try JSONDecoder().decode([adcategory].self, from: data)
                            var categoryList: [String: Int] = [:]
                            if let myAds = myAds, let nearbyAds = nearbyAds {
                                for category in adcategories {
                                    myCategory[category.name] = category.originalid
                                    let myAdsCount = myAds.filter { $0.adcategory == category.originalid }.count
                                    categoryList[category.name] = (categoryList[category.name] ?? 0) + myAdsCount

                                    let nearbyAdsCount = nearbyAds.filter { $0.adcategory == category.originalid }.count
                                    categoryList[category.name] = (categoryList[category.name] ?? 0) + nearbyAdsCount
                                }
                                sortedCategoryList = categoryList.sorted { $0.key < $1.key }
                                sortedCategoryList = sortedCategoryList.filter { $0.value > 0 }
                            }
                        }
                        if key == "getmainimages" {
                            mainimages = try JSONDecoder().decode([mainimage].self, from: data)
                        }
                        if key == "getperk" {
                            perks = try JSONDecoder().decode([perk].self, from: data)
                        }
                        if key == "getuser" {
                            let items = try JSONDecoder().decode(ResponseData.self, from: data)
                            myuser = items.user
                            myAds = items.myads
                            nearbyAds = items.nearby
                            wsyc = items.wsyc
                            myorg = items.org
                            communities = items.community
                            print(myAds)
                    
                        }
                        if key == "getorganisations" {
                            Organisations = try JSONDecoder().decode([Organisation].self, from: data)
                        }
                        if key == "getpostcode" {
                            let this = try JSONDecoder().decode(postcode.self, from: data)
                            myuser.userhometown =  this.place
                            userpostlat = this.lat
                            userpostlon = this.lon
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                    print("ici")
                    myuser.userprofile = 0
                }
                completion()
            }
            task.resume()
        }
    }
    
    class func setappleuser(name: String, notification: String, token: String, channel: String) -> String? {
                
        var responseString: String?
        var request = URLRequest(url: URL(string: "https://appservice.share50.no/setappleuser")!)
        let json: [String: Any] = [
               "channel": channel,
               "notification": notification,
               "id_token": token,
               "name": name
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                responseString = String(data: data, encoding: .utf8)
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any] {
                    let pushNotifications = PushNotifications.shared
                    let channelresponse = json["channel_overwrite"] as! String
                    if channelresponse == "added" {
                        responseString = "new"
                        try? pushNotifications.addDeviceInterest(interest: channel)
                    } else {
                        KeychainSwift().set("1", forKey: "profile")
                        KeychainSwift().set(channelresponse, forKey: "channel")
                        responseString = "old"
                        try? pushNotifications.addDeviceInterest(interest: channelresponse)
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return responseString
    }
   
}
