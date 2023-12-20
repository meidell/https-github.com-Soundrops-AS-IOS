//
//  LaunchScreenViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 20/12/2018.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var img_logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.img_logo.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
     
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.img_logo.alpha = 1.0
            }, completion: nil)
        })
    }

}
