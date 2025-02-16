//
//  AdvertisorList_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 03.01.23.
//  Copyright © 2023 Jan Erik Meidell. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class AdvertisorList_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var i: Int = 0
    var j: Int = 0
    var count: Int = 0
    var half:Int = 0
    var seenCompanyNames = Set<String>()
    var Ads = [ads]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        c_api.getrequest(params: "", key: "getcompanylogos") {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            
            self.half = (Companies!.count/2)
            let remainder = Companies!.count % 2
            if remainder == 1  {self.half += 1}
                    
            self.table.dataSource = self
            self.table.delegate = self
            self.table.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            self.btnBack.frame.size.width=self.btnBack.frame.height
            self.btnBack.backgroundColor = .white
            self.btnBack.layer.cornerRadius = self.btnBack.frame.width / 2
            self.btnBack.layer.borderWidth = 1
            self.btnBack.layer.borderColor = myColour2.cgColor
            self.btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
            let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
            let image4 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            self.btnBack.setImage(image4, for: .normal)
            self.btnBack.imageView?.contentMode = .scaleAspectFit
          
        }
        

    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return half
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdvertisorList_TableViewCell
       
        if  Companies!.count > (i) {
            AF.request(Companies![i].logo!).responseImage { response in
                switch response.result {
                case .success(let image):
                    cell.icon1.image = image
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
               
            }
        }
        if  Companies!.count > (i+1) {
            AF.request(Companies![i+1].logo!).responseImage { response in
                switch response.result {
                case .success(let image):
                    cell.icon2.image = image
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
               
            }
        }
       
        i+=2
        let myColour = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        cell.icon1.layer.borderColor = myColour.cgColor
        cell.icon1.layer.borderWidth = 1
        cell.icon1.layer.cornerRadius = 8
        cell.icon1.layer.masksToBounds = true
        cell.icon1.clipsToBounds=true
        cell.icon1.frame = CGRect(x: cell.frame.width*0.5-130, y: 0, width: 120, height: 80)
        cell.icon2.layer.borderColor = myColour.cgColor
        cell.icon2.layer.borderWidth = 1
        cell.icon2.layer.cornerRadius = 8
        cell.icon2.layer.masksToBounds = true
        cell.icon2.clipsToBounds=true
        cell.icon2.frame = CGRect(x: cell.frame.width*0.5+10, y: 0, width: 120, height: 80)
        return cell
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "advertisor_to_profile1", sender: self)
    }
}
