//
//  MyPage_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 14.12.22.
//  Copyright © 2022 Jan Erik Meidell. All rights reserved.
//

import UIKit

class MyPage_ViewController: UIViewController {
    
    @IBOutlet weak var buttonMyPerks: UIButton!
    @IBOutlet weak var btnCategories: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func btnMyFavourites(_ sender: Any) {
        g_mod="follow"
        self.performSegue(withIdentifier: "seque_myPage_to_campaignList", sender: self)
    }
    
    @IBAction func buttonMyPerks(_ sender: Any) {
        self.performSegue(withIdentifier: "mypage_to_perks", sender: self)
    }
    
    @IBAction func btnCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "mypage_to_categories", sender: self)
    }
    
    @IBAction func btnMyOrg(_ sender: Any) {
        self.performSegue(withIdentifier: "perks_to_organisation", sender: self)

    }
    
}

