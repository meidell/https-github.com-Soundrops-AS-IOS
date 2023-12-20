import UIKit
import Alamofire
import AlamofireImage


class Campaign_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var img_heart: UIImageView!
    @IBOutlet weak var cellCampaign: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourites: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnHome: UIButton!

    var didScroll:Bool = false
    var myHeight: Double = 0
    var myWidth: Double = 0
    var latitude:Double = 0
    var longitude:Double = 0
    var mycalc: Int = 0
    var Ads: [ads]?
    var myWsyc : Bool = false
    

    var colourBackground: UIColor = UIColor( red: 180/255, green: 205/255, blue:85/255, alpha: 1.0 )
    let documentsDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isConnectedtoWifi = c_wifi.isWiFiConnected()
        
        if cmptype == "myads" && (myAds?.count ?? 0) > 0 {
            Ads = filterUniqueAds(myAds)
            //adding communities to ads
            for (index, community) in communities!.enumerated() {
                let communityAd = ads(
                    id: community.id,
                    headline: community.heading,
                    message: community.story,
                    calltoaction: 0,
                    calltoactionresource: "",
                    outlets: nil,
                    logo: community.imagestream,
                    companyname: "Community",
                    companyid: 0,
                    image: "",
                    exclusive: 0,
                    adcategory: 0,
                    video: nil,
                    following: 0
                )
                // Insert the new ad at every third position
                let insertionIndex = index * 3 + 2
                print(Ads!.count,insertionIndex)
                Ads?.insert(communityAd, at: insertionIndex)
            }
            // Create an ads element using the properties from wsyc
            let newAd = ads(
                id: 0,
                headline: wsyc?.slogan,
                message: "",
                calltoaction: 0,
                calltoactionresource: "",
                outlets: nil,
                logo: wsyc?.logostream,
                companyname: wsyc?.companyname,
                companyid: 0,
                image: "",
                exclusive: 0,
                adcategory: 0,
                video: nil,
                following: 0
            )
            Ads?.insert(newAd, at: 1)
            myWsyc = true
        }

        if cmptype == "nearby" {
            Ads = filterUniqueAds(nearbyAds)
        }
        if cmptype == "category" {
            if let ads = filterUniqueAds(myAds) {
                Ads = ads.filter { $0.adcategory == userCategory }
            }
            if let ads = filterUniqueAds(nearbyAds) {
                let filteredAds = ads.filter { $0.adcategory == userCategory }
                Ads = Ads ?? [] + filteredAds
            }
        }
        if cmptype == "follow" {
            if let ads = filterUniqueAds(myAds) {
                Ads = ads.filter { $0.following == 1 }
            }
            if let ads = filterUniqueAds(nearbyAds) {
                let filteredAds = ads.filter { $0.following == 1 }
                Ads = Ads ?? [] + filteredAds
            }
        }
        fillcss()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func filterUniqueAds(_ inputAds: [ads]?) -> [ads]? {
        guard let inputAds = inputAds else { return nil }
        
        var uniqueIDs = Set<Int>()
        
        return inputAds.filter { ad in
            let isNew = uniqueIDs.insert(ad.id).inserted
            return isNew
        }
    }
    
    func fillcss() {
        
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
        
        btnFavourites.frame.size.width=btnFavourites.frame.height
        btnFavourites.backgroundColor = .white
        btnFavourites.layer.cornerRadius = btnFavourites.frame.width / 2
        btnFavourites.layer.borderWidth = 1
        btnFavourites.layer.borderColor = myColour2.cgColor
        btnFavourites.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        if didScroll == false {
            let image2 = UIImage(systemName: "heart.fill", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            btnFavourites.imageView?.contentMode = .scaleAspectFit
        } else {
            let image2 = UIImage(systemName: "heart.fill", withConfiguration: largeConfig2)?.withTintColor(.red, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            btnFavourites.imageView?.contentMode = .scaleAspectFit
        }
        didScroll=false

        btnCategory.frame.size.width=btnCategory.frame.height
        btnCategory.backgroundColor = .white
        btnCategory.layer.cornerRadius = btnCategory.frame.width / 2
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.borderColor = myColour2.cgColor
        btnCategory.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "list.dash", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnCategory.setImage(image3, for: .normal)
        btnCategory.imageView?.contentMode = .scaleAspectFit
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)

        switch cmptype {
        case "follow":
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
        default:
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "campaign_to_dashboard", sender: self)
    }
    
    @IBAction func btnFavourites(_ sender: Any) {
        
        switch cmptype {
        case "follow":
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            cmptype = "myads"
        default:
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            cmptype = "follow"
        }
        if cmptype == "myads" {
            Ads = filterUniqueAds(myAds)
        }

        if cmptype == "nearby" {
            Ads = filterUniqueAds(nearbyAds)
        }

        if cmptype == "follow" {
            if let ads = filterUniqueAds(myAds) {
                Ads = ads.filter { $0.following == 1 }
            }
            
            if let ads = filterUniqueAds(nearbyAds) {
                let filteredAds = ads.filter { $0.following == 1 }
                Ads = Ads ?? [] + filteredAds
            }
        }
        tableView.reloadData()
       
    }
    
    //  override func viewDidAppear(_ animated: Bool) {self.navigationController?.isNavigationBarHidden = true}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
           if translation.y > 0 {
               // swipes from top to bottom of screen -> down
               UIView.animate(withDuration: 0.1, delay: 0, animations: {
                   self.btnHome.alpha = 1
                   self.btnCategory.alpha = 1
                   self.btnFavourites.alpha = 1
               }, completion: nil)
           } else {
               // swipes from bottom to top of screen -> up
               if didScroll == true {
                   UIView.animate(withDuration: 0.5, delay: 0, animations: {
                       self.btnHome.alpha = 0
                       self.btnCategory.alpha = 0
                       self.btnFavourites.alpha = 0
                   }, completion: nil)
               }
               didScroll = true
           }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if  Ads![indexPath.row].companyname == "Community" {
            return 340
        } else {
            if myWsyc && indexPath.row == 1 {
                return 240
            } else {
                return 130
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ads = Ads {
            let adsCount = ads.count
            return adsCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Campaign_Detail_Cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.lbl_title.text = (Ads?[indexPath.row].headline)!
        cell.lbl_title.isHidden=false
        cell.lbl_title.numberOfLines = 3
        cell.lbl_title.lineBreakMode = .byWordWrapping
        cell.lbl_title.frame = CGRect(x: 150, y: 30, width: 130, height: 80)
        
        cell.lblCompany.text=Ads?[indexPath.row].companyname!.uppercased()

        if myHeight == 0 { myHeight = cell.img_campaign.frame.height}
        cell.img_campaign.backgroundColor = UIColor.white
        cell.img_campaign.alpha = 1
        cell.img_campaign.layer.masksToBounds = true
        cell.img_campaign.clipsToBounds=true
        cell.img_campaign.layer.cornerRadius = 10
        cell.img_campaign.frame = CGRect(x: 1, y: 36, width: myHeight/0.68, height: myHeight)
        cell.img_campaign.layer.maskedCorners = [ .layerMinXMaxYCorner]
        let getImage = Ads?[indexPath.row].logo
        Alamofire.request(getImage!).responseImage { [self] response in
            let image = response.result.value
            self.imageCache.setObject(image!, forKey: Ads?[indexPath.row].image as AnyObject)
            cell.img_campaign.image = image
        }
        
        let distanceInMeters = 1000*2
        cell.lbl_kilometer.text = String(format: "%.00f m", distanceInMeters)
        cell.lbl_kilometer.frame.origin.x =   CGFloat(cell.frame.size.width*0.37)
        let myColour2 = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        let myColour3 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        cell.img_back.layer.cornerRadius = 10.0
        cell.img_back.layer.borderColor = myColour2.cgColor
        cell.img_back.layer.borderWidth = 1
        cell.img_back.backgroundColor = myColour3
        cell.img_back.frame.size.width=cell.frame.size.width
        cell.lblCompany.frame.origin.x = 10
        cell.img_arrow.isHidden = true
        
        if  Ads?[indexPath.row].companyname == "Community" {
            let width:CGFloat = cell.frame.size.width-4
            let height:CGFloat = cell.frame.size.width*0.64
            cell.img_campaign.frame = CGRect(x: 1, y: 30, width: 1.03*width, height: height)
            cell.img_campaign.layer.cornerRadius = 0
            cell.img_back.frame.size.height=330
            cell.lbl_title.frame = CGRect(x: 30, y: 200, width: 130, height: 80)
        }
        print(indexPath.row,myWsyc)
        if indexPath.row == 1 && myWsyc {
            let width:CGFloat = cell.frame.size.width-4
            let height:CGFloat = cell.frame.size.width*0.64
            cell.img_campaign.frame = CGRect(x: 1, y: 30, width: 0.5*width, height: 0.5*height)
            cell.img_campaign.layer.cornerRadius = 0
            cell.img_back.frame.size.height=240
            cell.lbl_title.frame = CGRect(x: 30, y: 240, width: 130, height: 80)
            cell.lbl_title.text = "We support your choice"

        }

        if let message = Ads?[indexPath.row].headline, message == "Coming soon" {
            cell.img_campaign.alpha = 0.5
            cell.lbl_title.alpha = 0.5
            cell.lblCompany.alpha = 0.5
        } else {
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  Ads?[indexPath.row].companyname! == "Community" || Ads?[indexPath.row].headline! == wsyc?.slogan || (Ads?[indexPath.row].headline)! == "Coming soon" {
        } else {
            if cmptype == "myads" {
                if let adsArray = myAds,
                   let selectedHeadline = Ads?[indexPath.row].headline,
                   let thisId = adsArray.enumerated().first(where: { $0.element.headline == selectedHeadline })?.offset {
                    cmpId = thisId
                }
            } else {
                cmpId = indexPath.row
            }
            c_api.patchrequest(company: String(Ads![indexPath.row].id), key: "stat", action: "8") {}
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is Category_ViewController {
        }
        if segue.destination is CampaignDetailViewController {
            let trans = CATransition()
            trans.type = CATransitionType.fade
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
        }
        if segue.destination is Profile1_ViewController {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
        }
        
        if segue.destination is Dashboard_ViewController {
            let trans = CATransition()
            if cmptype == "nearby" {
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromLeft
                
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.25
                self.navigationController?.view.layer.add(trans, forKey: nil)
            } else {
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromRight
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.25
                self.navigationController?.view.layer.add(trans, forKey: nil)
            }
        }
    }
}
