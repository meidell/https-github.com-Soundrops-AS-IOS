//
//  SubCategoryViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 18.06.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Alamofire


class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
   // var URL_GET_DATA = "http://webservice.soundrops.com/V1/SubCategories/Restaurants"
    var categories = [SubCategories]()
    var data: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let URL_GET_DATA = "http://webservice.soundrops.com/V1/SubCategories/" + data
        
        print(URL_GET_DATA,data)
        
    
        Alamofire.request(URL_GET_DATA).responseJSON { response in
            if let json = response.result.value {
                let categoriesArray: NSArray = json as! NSArray
                for i in 0..<categoriesArray.count {
                    self.categories.append(SubCategories(
                        id: (categoriesArray[i] as AnyObject).value(forKey: "ID") as? Int,
                        name: (categoriesArray[i] as AnyObject).value(forKey: "Name") as? String
                    ))
                }
                self.tableView.reloadData()
            }
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category: SubCategories
        category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSubCategoryForme", sender: self)
    }
    
    
    
}
