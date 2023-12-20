//
//  ThankYouViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 10.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.performSegue(withIdentifier: "Dashboard", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
