//
//  APIService.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 28.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class APIService: NSObject {
    
    let query = "getUserCampaigns"
    lazy var endPoint: String = { return "http://webservice.soundrops.com/V1/Campaigns/3"}()
    
    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        guard let url = URL(string: endPoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                        print(completion)
                    }
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
}

enum Result <T>{
    case Success (T)
    case Error(String)
}
