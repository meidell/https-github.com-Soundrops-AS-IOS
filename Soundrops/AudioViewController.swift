//
//  AudioViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 06.09.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit

class Profile3_ViewController: UIViewController {

    var user:[User]? = nil
    var myAUdio: Int = 0
    var name: String = ""
    var memail: String = ""
    var myaccept: String = ""
    var age: String = ""
    var organisation: String = ""
    var gender: String = ""
    var country: String = ""
    var idOrg:String = ""
    var uniqueID: String = ""
    var audio: Int = 0
    
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func mySwitch(_ sender: Any) {
        if mySwitch.isOn {
            audio=1
            
        } else {
            audio=0
            
        }
        
//        CoreDataHandler.deleteObject()
//        _ = CoreDataHandler.saveObject(name: name, gender: gender, age: age, organisation: organisation, id: idOrg, audio: audio, country: country, myID: uniqueID, mymail: memail, myaccept: (self.user?.first?.myaccept)!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.user = CoreDataHandler.fetchObject()
//        
//        for i in self.user! {
//            gender = i.gender!
//            age = i.age!
//            organisation = i.organisation!
//            name = i.name!
//            idOrg = i.id!
//            country = i.country!
//            myAUdio = Int(i.audio)
//            uniqueID = i.myID!
//            
//            
//        }
        
        if myAUdio == 1 {
            mySwitch.setOn(true, animated:true)
        } else {
            mySwitch.setOn(false, animated:true)
        }
   
        

    }

}
