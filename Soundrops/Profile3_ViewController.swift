//
//  AudioViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 06.09.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import CoreData


class Profile3_ViewController: UIViewController {

    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "profile3_to_profile1", sender: self)
    }
    
    @IBAction func mySwitch(_ sender: Any) {
        if mySwitch.isOn {
            d_me["audio"]="true"
        } else {
            d_me["audio"]="false"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if d_me["audio"]==nil {d_me["audio"]="true"}
        
        if d_me["audio"]! == "true" {
            mySwitch.setOn(true, animated:true)
        } else {
            mySwitch.setOn(false, animated:true)
        }
        
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
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
    }
}
