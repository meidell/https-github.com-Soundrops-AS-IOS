//
//  Learning_2_ViewController.swift
//  Share//50
//
//  Created by Jan Erik Meidell on 25.11.19.
//  Copyright © 2019 Jan Erik Meidell. All rights reserved.
//

import UIKit

class Learning_2_ViewController: UIViewController {

     @IBOutlet weak var btnContinue: UIButton!
       
       @IBAction func btn_continue(_ sender: Any) {
             self.performSegue(withIdentifier: "learning2_to_register1", sender: self)
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           
           let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
           btnContinue.layer.cornerRadius = 5.0
           btnContinue.layer.borderColor = myColour2.cgColor
           btnContinue.layer.borderWidth = 1
       }
}
