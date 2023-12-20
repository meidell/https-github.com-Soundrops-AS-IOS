//
//  SaveStats.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 27.12.22.
//  Copyright © 2022 Jan Erik Meidell. All rights reserved.
//

import Foundation

class SaveStats {
    
    class func postStats(cmp_id: Int, cmp_action: Int) {
        
        let json: [String: Any] = ["user_id":userChannel,"cmp_action":cmp_action,"cmp_id":cmp_id]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlString:String = "https://appservice.soundrops.com/stats/set"
        var myrequest = URLRequest(url: URL(string:urlString)!)
        myrequest.httpMethod = "POST"
        myrequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        myrequest.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
        }
        task.resume()
    }
    
    class func postStatsPerks(cmp_id: String, cmp_action: Int) {
        
        let json: [String: Any] = ["id":cmp_id,"action":cmp_action]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlString:String = "https://appservice.soundrops.com/perks/set"
        var myrequest = URLRequest(url: URL(string:urlString)!)
        myrequest.httpMethod = "POST"
        myrequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        myrequest.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
        }
        task.resume()
    }
}
