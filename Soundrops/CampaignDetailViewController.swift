import UIKit
import Alamofire
import AlamofireImage
import Accounts
import MessageUI
import CoreLocation
import AVKit
import AVFoundation

class CampaignDetailViewController: UIViewController {
    
    var data: String = ""
    var window: UIWindow?
    var player : AVPlayer?
    var playerItem:AVPlayerItem?
    var playerLayer = AVPlayerLayer()
    var boxView = UIView()
    var updatefollow: Bool = false
    var cmp:String = ""
    var i: Int = 0
    var distanceInMeters: Double = 0
    var Ads: [ads]?
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var img_sound_off: UIImageView!
    @IBOutlet weak var btn_sound: UIButton!
    @IBOutlet weak var view_player: UIView!
    @IBOutlet weak var lbl_exclusive: UILabel!
    @IBOutlet weak var lbl_company: UILabel!
    @IBOutlet weak var textVoucher: UILabel!
    @IBOutlet weak var startTextLabel: UILabel!
    @IBOutlet weak var cmpLogo: UIImageView!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var Action1: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var map: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "campaign_to_campaigns", sender: self)
    }
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "campaign_to_dashboard", sender: self)
    }
    
    @IBAction func btnMap(_ sender: Any) {
        c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "14") {}
        self.performSegue(withIdentifier: "campaigndetail_to_map", sender: self)
    }
    
    @IBAction func btn_sound(_ sender: Any) {
        
        if player?.volume == 10 {
            player?.volume = 0
            img_sound_off.image = UIImage(named: "sound_off")
        } else {
            player?.volume = 10
            img_sound_off.image = UIImage(named: "sound_on")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        if cmptype == "myads" { Ads = myAds?.filter { $0.headline != "Coming soon" }}
        if cmptype == "nearby" {Ads = nearbyAds?.filter { $0.headline != "Coming soon" }}
        if cmptype == "follow" {
            if let ads = myAds {
                Ads = ads.filter { $0.following == 1 }
            }
            if let ads = nearbyAds {
                let filteredAds = ads.filter { $0.following == 1 }
                Ads! += filteredAds
            }
        }
        if cmptype == "category" {
            if let ads = myAds {
                Ads = ads.filter { $0.adcategory == userCategory }
            }
            if let ads = nearbyAds {
                let filteredAds = ads.filter { $0.adcategory == userCategory }
                Ads! += filteredAds
            }           
        }
        
        ButtonCss()
    
        if let viewWithTag = self.view.viewWithTag(102) {viewWithTag.removeFromSuperview()}

            if Ads?[cmpId].following == 0 {
                let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                follow.setImage(image2, for: .normal)
            } else {
                let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                follow.setImage(image2, for: .normal)
            }
            self.startTextLabel.text = Ads![cmpId].headline
            let frame1 = startTextLabel.frame //Frame of label
            let bottom = CALayer()
            bottom.frame = CGRect(x: 0, y: frame1.height, width: frame1.width, height: 1)
            bottom.backgroundColor = UIColor.gray.cgColor
            startTextLabel.layer.addSublayer(bottom)
            self.Action1.setTitle(Ads![cmpId].calltoactionresource, for: UIControl.State.normal)
        
            if Ads?[cmpId].video != nil {
                //
                player = AVPlayer(url: URL(string: Ads![cmpId].video!)!)
                playerLayer = AVPlayerLayer(player: player!)
                
                //voucherImage.frame.origin.y = self.view.frame.size.height*0.42
                
                view_player.isHidden = false
                img_sound_off.isHidden = false
                btn_sound.isHidden = false
                
                playerLayer.frame = self.view_player.bounds
                playerLayer.frame.origin.x = 0
                playerLayer.frame.origin.y = self.voucherImage.frame.origin.y
                playerLayer.frame.size.width = UIScreen.main.bounds.width
                
                playerLayer.videoGravity = .resizeAspectFill

                self.view.layer.addSublayer(playerLayer)
                player?.play()
                player?.volume = 0

                self.voucherImage.image = nil
                self.voucherImage.isHidden = false
                view_player.layer.masksToBounds = true
                view_player.clipsToBounds = true
                view_player.layer.cornerRadius = 8
                view_player.layer.masksToBounds = true
            } else {
                img_sound_off.isHidden = true
                btn_sound.isHidden = true
                view_player.isHidden = true
                self.voucherImage.isHidden = false
                if Ads?[cmpId].image != nil {
                    Alamofire.request(Ads![cmpId].image!).responseImage { response in
                        if let image = response.result.value {
                            self.voucherImage.image = image
                        }
                    }
                } else {
                    self.voucherImage.image = nil
                }
            }
            self.textVoucher.text = Ads![cmpId].message
            self.lbl_company.text? = Ads![cmpId].companyname!.uppercased()
            Alamofire.request((Ads?[cmpId].logo)!).responseImage { [self] response in
                if let image = response.result.value {
                    let imageView = UIImageView(image: image)
                    if  Ads?[cmpId].video != nil {
                        imageView.frame = CGRect(x: self.voucherImage.frame.width*0.75, y:self.voucherImage.frame.height*1.02, width: self.voucherImage.frame.width*0.25, height: self.voucherImage.frame.width*0.25*0.64)
                    } else {
                        imageView.frame = CGRect(x: self.voucherImage.frame.width*0.75, y:self.voucherImage.frame.height*1.02, width: self.voucherImage.frame.width*0.25, height: self.voucherImage.frame.width*0.25*0.64)
                    }
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 8
                    imageView.layer.masksToBounds = true
                    imageView.clipsToBounds = true
                    imageView.tag = 102
                    self.view.addSubview(imageView)
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is Campaign_ViewController {
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
    }
    
    @IBAction func btnAction(_ sender: Any) {
        c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "3") {}
        if let url2 = URL(string: Ads![cmpId].calltoactionresource!) {
            UIApplication.shared.open(url2, options: [:])}
    }
    
    @IBAction func btnFollow(_ sender: Any) {
        if Ads![cmpId].following == 1 {
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            follow.setImage(image2, for: .normal)
            Ads?[cmpId].following = 0
        } else {
            c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "11") {}
            let image2 = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            follow.setImage(image2, for: .normal)
            Ads?[cmpId].following = 1
        }
        c_api.patchrequest(company: String(Ads![cmpId].companyid!), key: "following", action: "") {
            let params = "/"+userChannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
            c_api.getrequest(params: params, key: "getuser") {
            }
        }
  
    }
    
    func ButtonCss() {

        if Ads?[cmpId].outlets != nil {
            map.isEnabled=true
        } else {
            map.isEnabled=false
        }
        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        map.layer.cornerRadius = 6
        map.layer.borderWidth = 1
        map.layer.borderColor = myColour.cgColor
        map.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "map.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        map.setImage(image3, for: .normal)
        map.imageView?.contentMode = .scaleAspectFit
        
        share.layer.cornerRadius = 6
        share.layer.borderWidth = 1
        share.layer.borderColor = myColour.cgColor
        share.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image = UIImage(systemName: "scale.3d", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        share.setImage(image, for: .normal)
        share.imageView?.contentMode = .scaleAspectFit
        
        follow.layer.cornerRadius = 6
        follow.layer.borderWidth = 1
        follow.layer.borderColor = myColour.cgColor
        follow.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
       // let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)

        follow.imageView?.contentMode = .scaleAspectFit
        
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
        
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour2.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image4 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image4, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func shareFB(_ sender: Any) {
        c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "9") {}
        let URL_AD = Ads?[cmpId].calltoactionresource
        let activityController = UIActivityViewController(activityItems: [URL_AD as Any], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func handleRightSwipe() {
        if cmpId > 0 {
            cmpId -= 1
            if player != nil {
                player!.pause()
                player = nil
                playerLayer.removeFromSuperlayer()
                img_sound_off.image = UIImage(named: "sound_off")
            }
            c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "12") {}
            self.viewDidLoad()
            self.viewWillAppear(true)
        }
    }

    @objc func handleLeftSwipe() {
       if cmpId < (Ads!.count-1) {
           cmpId += 1
           if player != nil {
               player!.pause()
               player = nil
               playerLayer.removeFromSuperlayer()
               img_sound_off.image = UIImage(named: "sound_off")
           }
           c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "12") {}
           self.viewDidLoad()
           self.viewWillAppear(false)
       }
    }
}


