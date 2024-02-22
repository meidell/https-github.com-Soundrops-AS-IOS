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

struct CompetitionData: Codable {
    let readablefrom: String
    let readableto: String
    let name: String
    let fromdata: Int
    let endDate: Int
    let rules: String
}

var currentCompetitionData: CompetitionData?

struct CompOrganisation: Codable {
    let name: String
    let logo: String
}

struct CompetitionLeaderboard: Codable {
    let _id: String
    let userCount: Int
    let organisation: CompOrganisation
}


struct CompetitionResponse: Codable {
    let competitionon: Int
    let competitiondata: CompetitionData
    let competitionleaderboard: [CompetitionLeaderboard]
}

var CompTens: [CompetitionLeaderboard]?

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
    let perkbtnname: String?
}
var perks: [perk]?

struct lead: Codable {
    var name: String?
    var comment: String?
}

var mylead = lead()

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
    var userlon: Double = 0
    var userlat: Double = 0
    var userprofile: Int = 0
    var userhometown: String = ""
    var userpostcode: String = ""
    var userpicture: String?
    var usernotifications: Int = 0
}
var myuser = user()

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

struct TopTen: Codable {
    let _id: String?
    let originalid: Int?
    let name: String?
    let logo: String?
    let followers: Int?
    let earnings: Int?

}
var TopTens: [TopTen]?

struct Organisation: Codable {
    let orgname: String?
    let orglogo: String?
    let orgid: Int?
    let orgrevenue: Int?
    let orgfollowers: Int?
}
var Organisations: [Organisation]?

struct Company: Codable {
    let name: String?
    let logo: String?
}
var Companies: [Company]?

var sortedCategoryList: [(key: String, value: Int)] = []

//global variables

var myCategory = [String: Int]()
var lastView: String = ""
var isConnectedtoWifi: Bool = false
var isConnectedtoNotifications: Bool = false
var showWarning: Bool = true
var userToken = ""
var cmpId = 0
var cmptype = ""
var perkId = 0
var mainImageCounter = 0
var userCategory = 0
var userChannel = ""
var currentOrg = 0
var badgeCount = 0
var competitionOn = 0
var NotificationReceived: String = "no"
var startedWithNotification: String = "no"
var userBadRequest: Bool = false
var QRadmin: Bool = false


class c_api {
    
    
    class func sendPatchRequest() {
        // Prepare the URL
        guard let url = URL(string: "https://statservice1.share50.no/stats/track") else { return }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        // Set the headers
        request.setValue("androidios", forHTTPHeaderField: "authorization")
        request.setValue("greatballsoffire", forHTTPHeaderField: "password")
        request.setValue("zYMTDDa6rI1727427536287", forHTTPHeaderField: "channel")
        request.setValue("zYMTDDa6rI1727427536287", forHTTPHeaderField: "channelid")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body
        let json: [String: Any] = [
            "lat": "0",
            "lng": "0",
            "channelid": "zYMTDDa6rI1727427536287",
            "cmpid": "570",
            "action": "10"
        ]
        
        // Convert the JSON dictionary to Data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error converting dictionary to JSON data: \(error)")
            return
        }
        
        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            if let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Response JSON: \(jsonResponse)")
                } else {
                    print("Unable to parse response data")
                }
            }
        }
        
        // Start the request
        task.resume()
    }

    
    class func geturls(key: String) -> String? {
        
        var urls = [String: String]()
        urls["getpostcode"] = "https://appservice1.share50.no/postcode"
        urls["getuser"] = "https://appservice1.share50.no/user"
        urls["gettopten"]  = "https://appservice1.share50.no/organisations/getoverhead"
        urls["getcompetition"]  = "https://appservice1.share50.no/competitions"
        urls["getperk"] = "https://appservice1.share50.no/perks/all"
        urls["getmainimages"] = "https://appservice1.share50.no/mainimages"
        urls["getcompanylogos"] = "https://appservice1.share50.no/companylogos"
        urls["updateuser"] = "https://appservice1.share50.no/updateuser"
        urls["setappleuser"] = "https://appservice1.share50.no/setappleuser"
        urls["getorganisations"] = "https://appservice1.share50.no/organisations"
        urls["getadcategories"]  = "https://appservice1.share50.no/adcategory/get"
        urls["following"]  = "https://appservice1.share50.no/following"
        urls["stat"]  = "https://statservice1.share50.no/stats/track"
        urls["discontinue"]  = "https://appservice1.share50.no/discontinueuser"
        urls["pairphone"]  = "https://appservice1.share50.no/pair/update"
        urls["insertlead"]  = "https://appservice1.share50.no/reqorg/insert"
        urls["notifications-on"]  = "https://appservice1.share50.no/notifications/on"
        urls["notifications-off"]  = "https://appservice1.share50.no/notifications/off"

        return urls[key]
    }
    
    class func deleterequest(channel: String, completion: @escaping (Bool) -> Void) {
        
        let urlString = geturls(key: "discontinue")!
        
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
            request.setValue(userChannel, forHTTPHeaderField: "channelid")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var jsonData: [String: Any] = [:]
            
            if key == "pairphone" {
                jsonData["token"] = action
            }
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
                       // let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
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
            
            if key == "insertlead" {
                jsonData["orgname"] = mylead.name
                jsonData["channel"] =  userChannel
                jsonData["personname"] = mylead.comment
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData) {
                    request.httpBody = jsonData
                }
            }
            
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
                jsonData["userlat"] = String(myuser.userlat)
                jsonData["userlong"] = String(myuser.userlon)
                jsonData["userage"] = String(myuser.userage)
                jsonData["org"] = String(myuser.userorg)
                jsonData["usergender"] = String(myuser.usergender)
                jsonData["usercountry"] = "NO"
                jsonData["username"] = myuser.username
                jsonData["userhometown"] = myuser.userhometown
                jsonData["userpostcode"] = myuser.userpostcode
                jsonData["notifications"] = isConnectedtoNotifications
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
                } else {
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                }
                completion()
            }
            task.resume()
        }
    }
    
    class func getrequest(params: String, key: String, completion: @escaping () -> Void) {
        //endstring parameters
        let urlString = geturls(key: key)! + params
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("androidios", forHTTPHeaderField: "authorization")
            request.setValue("greatballsoffire", forHTTPHeaderField: "password")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(userChannel, forHTTPHeaderField: "channel")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                let httpResponse = response as? HTTPURLResponse
                if httpResponse!.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    do {
                        if key == "getadcategories" {
                            let adcategories = try JSONDecoder().decode([adcategory].self, from: data)
                            var categoryList: [String: Int] = [:]
                            var processedIDs: Set<Int> = Set()

                            if let myAds = myAds, let nearbyAds = nearbyAds {
                                for category in adcategories {
                                    myCategory[category.name] = category.originalid
                                    
                                    let myAdsCount = myAds.filter { $0.adcategory == category.originalid }.count
                                    categoryList[category.name] = (categoryList[category.name] ?? 0) + myAdsCount
                                    processedIDs.formUnion(myAds.map { $0.id })

                                    let nearbyAdsCount = nearbyAds.filter { $0.adcategory == category.originalid && !processedIDs.contains($0.id) }.count
                                    categoryList[category.name] = (categoryList[category.name] ?? 0) + nearbyAdsCount
                                    processedIDs.formUnion(nearbyAds.map { $0.id })
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
                        }
                        if key == "getorganisations" {
                            Organisations = try JSONDecoder().decode([Organisation].self, from: data)
                        }
                        if key == "gettopten" {
                            TopTens = try JSONDecoder().decode([TopTen].self, from: data)
                        }
                        if key == "getcompetition" {
                            let competitionResponse = try JSONDecoder().decode(CompetitionResponse.self, from: data)
                            CompTens = competitionResponse.competitionleaderboard
                            currentCompetitionData = competitionResponse.competitiondata
                            competitionOn = competitionResponse.competitionon
                            print(competitionOn)
                        }
                        if key == "getcompanylogos" {
                            Companies = try JSONDecoder().decode([Company].self, from: data)
                        }
                        if key == "getpostcode" {
                            let this = try JSONDecoder().decode(postcode.self, from: data)
                            myuser.userhometown =  this.place
                            myuser.userlat  = this.lat
                            myuser.userlon  = this.lon
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                        if key == "getcompetition" {
                            competitionOn = 0
                        }
                    }
                } else {
                    if key == "getuser" {
                        userBadRequest = true
                    }
                    print("Non-200 status code received: \(httpResponse!.statusCode)")
                }
                completion()
            }
            task.resume()
        }
    }
    
    class func setappleuser(name: String, notification: String, token: String, channel: String) -> String? {
        let beamsClient = PushNotifications.shared
        var responseString: String?
        var request = URLRequest(url: URL(string: "https://appservice1.share50.no/setappleuser")!)
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
                    let profile_completed = json["profile_completed"] as! Int
                    let pushNotifications = PushNotifications.shared
                    let channelresponse = json["channel_overwrite"] as! String
                    if channelresponse == "added" {
                        myuser.userprofile = 0
                    } else {
                        myuser.userprofile = profile_completed
                        userChannel = channelresponse
                    }
                    KeychainSwift().set(userChannel, forKey: "channel")
             //       try? pushNotifications.addDeviceInterest(interest: userChannel)
                    beamsClient.start(instanceId: "01951d5b-82d4-4b3c-a9d1-dca0353072fd")
                    beamsClient.registerForRemoteNotifications()
                    do {
                        try beamsClient.addDeviceInterest(interest: userChannel)
                    } catch {
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
