//
//  TodayViewController.swift
//  SoundropsWidget
//
//  Created by Jan Erik Meidell on 08.06.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var mytext: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        mytext.text="Hello"
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  if let name = UserDefaults.init(suiteName: "group.Soundrops.widget")?.value(forKey: "name") {
     //       label.text = name as? String
     //   }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
