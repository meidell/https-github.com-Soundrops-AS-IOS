//
//  Learning_1_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 25.11.19.
//  Copyright © 2019 Jan Erik Meidell. All rights reserved.
//

import UIKit

class Learning_1_ViewController: UIViewController {
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBAction func btn_continue(_ sender: Any) {
          self.performSegue(withIdentifier: "segue_learn_1_to_start", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnContinue.layer.cornerRadius = 5.0
        btnContinue.layer.borderColor = myColour2.cgColor
        btnContinue.layer.borderWidth = 1
        
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Continue", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btnContinue.setAttributedTitle(attributedString, for: .normal)
    }
}
