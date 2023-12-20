//
//  Test.swift
//  Soundrops
//
//  Created by JEM on 18.11.2023.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import Foundation

class SDSuperGlobals: NSObject {

    var searchOrgList: [Any] = []
    var sdUserInsertResult: [Any] = []
    var perks: [Any] = []
    var currentOutlets: [Any] = []
    var adCategories: [Any] = []
    var myAds: [Any] = []
    var nearby: [Any] = []
    var community: [Any] = []
    var mergedAdSet: [Any] = []
    var mergedFavourites: [Any] = []
    var catSpecificAdds: [Any] = []
    var advertisers: [Any] = []
    
    var wsyc: [AnyHashable: Any] = [:]
    var userUpdate: [AnyHashable: Any] = [:]
    
    var perksLoaded = false
    var userDataSet = false
    
    var orgLogo = ""
    var orgImg = ""
    var orgDesc = ""
    var orgName = ""
    var sponsorLogo = ""
    var sponsorName = ""
    var sponsorSlogan = ""
    var userCity = ""
    var userDisplayName = ""
    var orgFollowers = ""
    var postcode = ""
    
    var orgFunds = 0
    var userOrgId = 0
    var userAge = 0
    var userGender = 0
    var userNotificMode = 0
    var screenWidth = 0
    var screenHeight = 0
    var orgId = 0
    var userLatitude = 0.0
    var userLongitude = 0.0
    var userPostcodeLatitude = 0.0
    var userPostcodeLongitude = 0.0
    var userInstallComplete: Bool?
    var userExists = false
    var fineLocationAccess = false
    var installationProcess = false
    var userPicture = ""
    var userChannel = ""
    var idCodeMatch = ""
    var homeImage = ""
    var delayTest = ""
    var profileCompleted = ""
    
    func getUserChannel() -> String {
        return userChannel
    }

    func setUserRealLocation(lat: Double, lon: Double) {
        userLatitude = lat
        userLongitude = lon
    }

    func checkUserDataForInsert() -> Bool {
        if userAge <= 15 || userGender < 1 {
            return false
        }

        if userPostcodeLongitude < 0.01 || userPostcodeLatitude < 0.01 || userCity.isEmpty {
            return false
        }

        return userDisplayName.count >= 1 && userOrgId >= 1
    }

    func getIdCodeMatch() -> String {
        return idCodeMatch
    }

    func setIdCodeMatch(_ idCodeMatch: String) {
        self.idCodeMatch = idCodeMatch
    }

    func setUserInsertResult(_ sdUserInsertResult: [Any]) {
        self.sdUserInsertResult = sdUserInsertResult
    }

    func setUserData(_ userData: [AnyHashable: Any]) throws {
        guard let user = userData["user"] as? [AnyHashable: Any] else { return }
        userInstallComplete = (user["userprofile"] as? Int ?? 0) > 0
        userDisplayName = String(describing: user["username"]).replacingOccurrences(of: "_", with: " ")
        
        if userInstallComplete ?? false {
            userPostcodeLongitude = user["userlon"] as? Double ?? 0.0
            userPostcodeLatitude = user["userlat"] as? Double ?? 0.0
        }

        userCity = String(describing: user["userhometown"])
        userPicture = String(describing: user["userpicture"])
        userOrgId = user["userorg"] as? Int ?? 0
        userGender = user["usergender"] as? Int ?? 0
        userAge = user["userage"] as? Int ?? 0
        userDataSet = true

        if let org = userData["org"] as? [AnyHashable: Any] {
            orgImg = "-"
            orgLogo = org["orglogo"] as? String ?? ""
            orgName = org["orgname"] as? String ?? ""
            orgId = org["orgid"] as? Int ?? 0
            orgFollowers = String(describing: org["orgfollowers"])
            orgFunds = org["orgrevenue"] as? Int ?? 0
            orgDesc = "-"
        }

        if let wsycData = userData["wsyc"] as? [AnyHashable: Any] {
            sponsorLogo = wsycData["logostream"] as? String ?? ""
            sponsorName = wsycData["companyname"] as? String ?? ""
            sponsorSlogan = wsycData["slogan"] as? String ?? ""
        }

        myAds = userData["myads"] as? [Any] ?? []
        nearby = userData["nearby"] as? [Any] ?? []
        community = userData["community"] as? [Any] ?? []
    }

    func mergeAdSets() throws {
        var uniqueIds = Set<Int>()
        mergedAdSet = []
        try mergedNearbyMyAds(array: myAds, uniqueIds: &uniqueIds)
        try mergedNearbyMyAds(array: nearby, uniqueIds: &uniqueIds)
    }

    func mergeFavourites() throws {
        mergedFavourites = []
        for i in 0..<mergedAdSet.count {
            if let ad = mergedAdSet[i] as? [AnyHashable: Any], let following = ad["following"] as? Int, following > 0 {
                mergedFavourites.append(ad)
            }
        }
    }

    private func mergedNearbyMyAds(array: [Any], uniqueIds: inout Set<Int>) throws {
        for i in 0..<array.count {
            if let ad = array[i] as? [AnyHashable: Any], let id = ad["id"] as? Int, !uniqueIds.contains(id) {
                mergedAdSet.append(ad)
                uniqueIds.insert(id)
            }
        }
    }

    func extractCatSpecificAdds(cat: Int) throws -> [Any] {
        catSpecificAdds = []
        for i in 0..<mergedAdSet.count {
            if let ad = mergedAdSet[i] as? [AnyHashable: Any], let adCategory = ad["adcategory"] as? Int, adCategory > cat {
                catSpecificAdds.append(ad)
            }
        }
        return catSpecificAdds
    }

    func getUserLatLong() -> [Double] {
        return [userLatitude, userLongitude]
    }
}

