//
//  PerksSingle_ViewController.swift
//  Share//50
//
//  Created by Jan Erik Meidell on 30.12.22.
//  Copyright © 2022 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class PerksSingle_ViewController: UIViewController {
    
    @IBOutlet weak var myHeadline: UILabel!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLogo: UIImageView!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myOutle: UILabel!
    @IBOutlet weak var myDisclaimer: UILabel!
    @IBOutlet weak var btnRabatt: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnTell: UIButton!
    
    @IBAction func btnRabatt(_ sender: Any) {
        c_api.patchrequest(company: String(perks![perkId].perkid), key: "stat", action: "3") {}
        let URL_AD = perks![perkId].perkurl!
        if let url2 = URL(string: URL_AD) {
        UIApplication.shared.open(url2, options: [:])}
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "perksingle_to_perkview", sender: self)
    }
    @IBAction func btnHome(_ sender: Any) {
        performSegue(withIdentifier: "perksingle_to_dashboard", sender: self)
    }
    
    @IBAction func btnTell(_ sender: Any) {
        
        c_api.patchrequest(company: String(perks![perkId].perkid), key: "stat", action: "16") {}
        
        let string1 = String(perks![perkId].perkid)
        let string2 = String(myuser.username)
        let perkIdString = String(string1).trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameString = String(string2).trimmingCharacters(in: .whitespacesAndNewlines)
        let encodedPerkIdString = perkIdString.data(using: .utf8)?.base64EncodedString() ?? ""
        let encodedUsernameString = usernameString.data(using: .utf8)?.base64EncodedString() ?? ""
        let urlString = "https://share50.no/perk/" + encodedPerkIdString + "/" + encodedUsernameString
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL")
        }

//        let data1 = base64Encode(String(perks![perkId].perkid))!
//        let data2 = base64Encode(myuser.username)!
//        let cmpurl = "https://share50.no/perk/"+data1+"/"+data2
//        let activityController = UIActivityViewController(activityItems: [cmpurl], applicationActivities: nil); present(activityController, animated: true, completion: nil)
    }

    func base64Encode(_ data: String) -> String? {
        guard let encodedData = data.data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        return encodedData
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnRabatt.layer.cornerRadius = 6
        btnRabatt.layer.borderWidth = 1
        btnRabatt.layer.borderColor = myColour.cgColor
        btnRabatt.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        btnRabatt.imageView?.contentMode = .scaleAspectFit

        btnTell.layer.cornerRadius = 6
        btnTell.layer.borderWidth = 1
        btnTell.layer.borderColor = myColour.cgColor
        btnTell.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        btnTell.imageView?.contentMode = .scaleAspectFit
    
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image2 = UIImage(systemName: "house.fill", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image2, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image4 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image4, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit

        AF.request(perks![perkId].perkimg!).responseImage { response in
            switch response.result {
            case .success(let image):
                self.myImage.image = image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            
            self.myImage.layer.cornerRadius = 8
            self.myImage.layer.masksToBounds = true
//            self.myImage.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        }

        AF.request(perks![perkId].perklogo!).responseImage { response in
            switch response.result {
            case .success(let image):
                self.myLogo.image = image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            self.myLogo.layer.cornerRadius = 8
            self.myLogo.layer.masksToBounds = true
            self.myLogo.frame = CGRect(x: self.myImage.frame.width*0.88, y:self.myImage.frame.height*1.10, width: self.myImage.frame.width*0.13, height: self.myImage.frame.width*0.13*0.64)
            self.myLogo.clipsToBounds = true
        }
        myTitle.text = perks![perkId].perkcompany!.uppercased()
        myDescription.text = perks![perkId].perkdescription!
        myHeadline.text = perks![perkId].perkname
        myOutle.text = perks![perkId].perkoutlets!
        myDisclaimer.text = perks![perkId].perkdisclaimer!
        if perks?[perkId].perkbtnname != nil {
            btnRabatt.setTitle(perks![perkId].perkbtnname, for: .normal)
            btnRabatt.isHidden=false
        } else {
            btnRabatt.isHidden=true
        }
        
    }
}
