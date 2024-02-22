//
//  Startafter_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 30.01.2024.
//  Copyright © 2024 Jan Erik Meidell. All rights reserved.
//


import UIKit

class Startafter_ViewController: UIViewController {
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBAction func btnContinue(_ sender: Any) {
        self.performSegue(withIdentifier: "startafter_to_register1", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        c_wifi.checkandGetLocation()
        
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnContinue.layer.cornerRadius = 5.0
        btnContinue.layer.borderColor = myColour2.cgColor
        btnContinue.layer.borderWidth = 1
        btnContinue.backgroundColor = UIColor.red
        btnContinue.titleLabel?.textColor = UIColor.white
        
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Velg en organisasjon", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btnContinue.setAttributedTitle(attributedString, for: .normal)
    }
}

//#Preview {
//    Startafter_ViewController()
//}
