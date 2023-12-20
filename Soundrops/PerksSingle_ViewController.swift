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
    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLogo: UIImageView!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myOutle: UILabel!
    @IBOutlet weak var myDisclaimer: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnTell: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "perksingle_to_perkview", sender: self)
    }
    @IBAction func btnHome(_ sender: Any) {
        performSegue(withIdentifier: "perksingle_to_dashboard", sender: self)
    }
    
    @IBAction func btnTell(_ sender: Any) {
        
        
        c_api.patchrequest(company: String(perks![perkId].perkid), key: "stat", action: "16") {}
        let URL_AD = perks![perkId].perkurl!
        let activityController = UIActivityViewController(activityItems: [URL_AD as Any], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        //let IdEncoded = id?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
      //  let userName = userDisplayName.uppercased().replacingOccurrences(of: "_", with: " ").data(using: .utf8)
      //  let UserNameEncoded = userName?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
      
      //  let URL_AD = "https://www.soundrops.com/perk/"+IdEncoded!+"/"+UserNameEncoded!
    //    let activityController = UIActivityViewController(activityItems: [URL_AD], applicationActivities: nil)
     //   present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnTell.setTitle("   Tell Somebody", for: .normal)
//        btnTell.semanticContentAttribute = .forceLeftToRight
        btnTell.layer.borderWidth = 1
        btnHome.layer.cornerRadius = 8
        btnTell.layer.borderColor = myColour2.cgColor
        btnTell.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "scale.3d", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnTell.setImage(image1, for: .normal)
        
        let attributedString4 = NSAttributedString(string: NSLocalizedString("    Tell Somebody", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnTell.setAttributedTitle(attributedString4, for: .normal)
        
        myLogo.frame.size.height = myLogo.frame.width*0.52
        
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image2 = UIImage(systemName: "house.fill", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image2, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour2.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image3, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit

        Alamofire.request(perks![perkId].perkimg!).responseImage { response in
            self.myImage.image = response.result.value
            self.myImage.layer.cornerRadius = 8
            self.myImage.layer.masksToBounds = true
//            self.myImage.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        }

        Alamofire.request(perks![perkId].perklogo!).responseImage { response in
            self.myLogo.image = response.result.value
            self.myLogo.layer.cornerRadius = 8
            self.myLogo.layer.masksToBounds = true
        }
      //  SaveStats.postStatsPerks(cmp_id: perkList[g_curr].id, cmp_action: 15)
        myTitle.text = perks![perkId].perkcompany!.uppercased()
        myDescription.text = perks![perkId].perkname!
        myOutle.text = perks![perkId].perkoutlets!
        myDisclaimer.text = perks![perkId].perkdisclaimer!
    }
}
