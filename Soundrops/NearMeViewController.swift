import UIKit
import Alamofire
import AlamofireImage
import CoreData

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    @IBOutlet weak var tableview: UITableView!
    
    let URL_GET_DATA = "http://webservice.soundrops.com/V1/Campaigns/3"
    var campaigns = [Campaign]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForMeTableViewCell
        
        let myColour = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = myColour.cgColor
        
        let campaign: Campaign
        campaign = campaigns[indexPath.row]
        cell.AddLabelView.text = campaign.startText
        
        Alamofire.request(campaign.imageUrl!).responseImage { response in
            if let image = response.result.value {
                cell.AddImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CampaignDetailViewController {
            destination.myID = campaigns[(tableview.indexPathForSelectedRow?.row)!].id!
            
            //campaigns[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor : UIColor = UIColor( red: 0.8, green: 0.8, blue:0.8, alpha: 1.0 )
        /* btnAll.layer.borderWidth = 1
         btnAll.layer.borderColor = myColor.cgColor
         btnToday.layer.borderWidth = 1
         btnToday.layer.borderColor = myColor.cgColor
         btnThisWeek.layer.borderWidth = 1
         btnThisWeek.layer.borderColor = myColor.cgColor */
        
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // self.tableView.separatorColor = UIColor.white
        
        Alamofire.request(URL_GET_DATA).responseJSON { response in
            if let json = response.result.value {
                let campaignsArray: NSArray = json as! NSArray
                for i in 0..<campaignsArray.count {
                    
                    self.campaigns.append(Campaign(
                        id: (campaignsArray[i] as AnyObject).value(forKey: "ID") as? Int,
                        startText: (campaignsArray[i] as AnyObject).value(forKey: "StartText") as? String,
                        endText: (campaignsArray[i] as AnyObject).value(forKey: "EndText") as? String,
                        callToAction1: (campaignsArray[i] as AnyObject).value(forKey: "CallToAction1") as? String,
                        imageUrl: (campaignsArray[i] as AnyObject).value(forKey: "Image") as? String,
                        calltoAction2: (campaignsArray[i] as AnyObject).value(forKey: "CallToAction2") as? String,
                        voucherText: (campaignsArray[i] as AnyObject).value(forKey: "voucherText") as? String,
                        campaignUrl: (campaignsArray[i] as AnyObject).value(forKey: "ImageVoucher") as? String,
                        website: (campaignsArray[i] as AnyObject).value(forKey: "website") as? String
                    ))
                }
                self.tableview.reloadData()
            }
        }
    }
}










