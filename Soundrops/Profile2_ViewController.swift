//
//  AboutViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 06.09.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class Profile2_ViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "profile2_to_profile1", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
