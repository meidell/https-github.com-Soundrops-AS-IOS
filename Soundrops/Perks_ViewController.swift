//
//  Perks_ViewController.swift
//  Share//50
//
//  Created by Jan Erik Meidell on 28.12.22.
//  Copyright © 2022 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Perks_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btnHome: UIButton!
    
    @IBAction func btnHome(_ sender: Any) {
        performSegue(withIdentifier: "perks_to_dashboard", sender: self)
    }
    
    var didScroll:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        table.dataSource = self
        table.delegate = self
        
        self.table.showsHorizontalScrollIndicator = false
        self.table.showsVerticalScrollIndicator = false
        
        didScroll=false
        
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "house.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image1, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
           if translation.y > 0 {
               // swipes from top to bottom of screen -> down
               UIView.animate(withDuration: 0.1, delay: 0, animations: {
                   self.btnHome.alpha = 1
               }, completion: nil)
           } else {
               // swipes from bottom to top of screen -> up
               if didScroll == true {
                   UIView.animate(withDuration: 0.5, delay: 0, animations: {
                       self.btnHome.alpha = 0
                   }, completion: nil)
               }
               didScroll = true
           }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        g_curr = indexPath.row
        c_api.patchrequest(company: String(perks![indexPath.row].perkid), key: "stat", action: "15") {}

        performSegue(withIdentifier: "perks_to_perksdetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perks!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PerkTableViewCell
        
        cell.background.backgroundColor = UIColor.black
        cell.background.layer.cornerRadius = 8
        cell.background.layer.masksToBounds = true

        Alamofire.request(perks![indexPath.row].perkimg!).responseImage { response in
            cell.mainImageView.image = response.result.value
            cell.mainImageView.layer.cornerRadius = 8
            cell.mainImageView.layer.masksToBounds = true
            cell.mainImageView.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        }
        
        Alamofire.request(perks![indexPath.row].perklogo!).responseImage { response in
            cell.iconImageView.image = response.result.value
            cell.iconImageView.layer.cornerRadius = 8
            cell.iconImageView.frame.size.height=cell.iconImageView.frame.width*0.52
            cell.iconImageView.layer.masksToBounds = true
        }
       
        cell.title.text = perks![indexPath.row].perkname!.uppercased()
        cell.title.textColor = UIColor.white
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }

}
