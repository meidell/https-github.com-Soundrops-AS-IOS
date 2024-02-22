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
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer = AVPlayerLayer()
    var boxView = UIView()
    var updatefollow: Bool = false
    var cmp: String = ""
    var i: Int = 0
    var Ads: [ads]?
    
    struct mapping: Codable {
        let id: Int
    }
    var MaptoAds: [mapping]?
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var fldDistance: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var img_sound_off: UIImageView!
    @IBOutlet weak var btn_sound: UIButton!
    @IBOutlet weak var view_player: UIView!
//    @IBOutlet weak var lbl_exclusive: UILabel!
    @IBOutlet weak var lbl_company: UILabel!
    @IBOutlet weak var startTextLabel: UILabel!
    @IBOutlet weak var cmpLogo: UIImageView!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var Nettside: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var map: UIButton!
    
    var textVoucher: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    
    @IBAction func Nettside(_ sender: Any) {
        c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "3") {}
        let URL_AD = Ads?[cmpId].calltoactionresource
        guard let url = URL(string: URL_AD!) else {
            print("Error: Invalid URL provided for webpage.")
            return
          }
          UIApplication.shared.open(url)
    }
    
    @IBOutlet weak var btnInfo: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "campaign_to_campaigns", sender: self)
    }
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "campaign_to_dashboard", sender: self)
    }
    
    @IBAction func btnMap(_ sender: Any) {
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
    
    @IBAction func btnInfo(_ sender: Any) {
        let alert = UIAlertController(title: "Til informasjon", message: "Alle annonser i share50-appen er underlagt norske lover om opphavsrett og er ikke ment for videredistribusjon på annen måte enn hva som er gjort mulig via appens delingsfunksjon.\n\n Enkelte tilbud er eksklusive og kun forbeholdt appens brukere. Dersom et tilbud blir endret vil alltid dato for siste endring være de gjeldende betingelser. Tilbudene er gyldige så lenge de er presentert i share50-appen.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if cmptype == "myads" || cmptype == "notification" {
            if let ads = myAds {
                Ads = ads.filter { $0.headline != "Coming soon" }
                if cmpId > ads.count {
                    if let index = Ads?.firstIndex(where: { $0.id == cmpId }) {
                        cmpId = index
                    } else {
                        cmpId = 0
                    }
                    cmptype = "myads"
                    NotificationReceived = "no"
                }
            }
        }
        
        if cmptype == "nearby" { 
            Ads = nearbyAds?.filter { $0.headline != "Coming soon" }
            if cmpId > nearbyAds?.count ?? 0 {
                if let index = Ads?.firstIndex(where: { $0.id == cmpId }) {
                    cmpId = index
                } else {
                    cmpId = 0
                }
            }
                
        }
        
        print(cmptype,cmpId)

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
        
        if Ads != nil {
            
            ButtonCss()
            
            view.bringSubviewToFront(btnInfo)
                  
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
            leftSwipeGesture.direction = .left
            view.addGestureRecognizer(leftSwipeGesture)

            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
            rightSwipeGesture.direction = .right
            view.addGestureRecognizer(rightSwipeGesture)
            
            view.addSubview(textVoucher)
                    
            if let viewWithTag = self.view.viewWithTag(102) { viewWithTag.removeFromSuperview() }

            if Ads?[cmpId].following == 0 {
                let image2 = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                follow.setImage(image2, for: .normal)
            } else {
                let image2 = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                follow.setImage(image2, for: .normal)
            }
            self.startTextLabel.text = Ads![cmpId].headline
            
            startTextLabel.removeBottomBorder()
            startTextLabel.addBottomBorder()
            
            btnInfo.backgroundColor = UIColor(white: 255, alpha: 1)
            
            imgArrow.frame.origin.x = 13
            imgArrow.isHidden = true
            if let firstAd = Ads?[cmpId] {
                let result = smallestDistance(adOutlets: firstAd.outlets)
                fldDistance.text = result
            } else {
                fldDistance.text = ""
            }
         
            if Ads?[cmpId].video != nil {
                //
                player = AVPlayer(url: URL(string: Ads![cmpId].video!)!)
                playerLayer = AVPlayerLayer(player: player!)
                
                //voucherImage.frame.origin.y = self.view.frame.size.height*0.42
                
                view_player.isHidden = false
                img_sound_off.isHidden = false
                btn_sound.isHidden = false
                
                playerLayer.frame = self.view_player.bounds
                playerLayer.frame.origin.x = 10
                playerLayer.frame.origin.y = self.voucherImage.frame.origin.y
                playerLayer.frame.size.width = UIScreen.main.bounds.width - 20
                playerLayer.frame.size.height = playerLayer.frame.size.width*0.69
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.cornerRadius = 10
                playerLayer.masksToBounds = true

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
                voucherImage.frame.origin.x = 10
                voucherImage.frame.size.width = UIScreen.main.bounds.width - 20
                voucherImage.layer.cornerRadius = 10
                voucherImage.layer.masksToBounds = true
                voucherImage.frame.size.height = voucherImage.frame.size.width*0.69
                
                img_sound_off.isHidden = true
                btn_sound.isHidden = true
                view_player.isHidden = true
                self.voucherImage.isHidden = false
                if Ads?[cmpId].image != nil {
                    AF.request(Ads![cmpId].image!).responseImage { response in
                        switch response.result {
                        case .success(let image):
                            self.voucherImage.image = image
                        case .failure(let error):
                            print("Error loading image: \(error)")
                        }
                    }
                } else {
                    self.voucherImage.image = nil
                }
            }
            
            if fldDistance.text == "" {
                textVoucher.frame.origin.y = startTextLabel.frame.origin.y + startTextLabel.frame.height + 5
            } else {
                textVoucher.frame.origin.y = startTextLabel.frame.origin.y + startTextLabel.frame.height + 30
            }
            
            self.textVoucher.text = Ads![cmpId].message
            if let text = textVoucher.text {
                let maxSize = CGSize(width: textVoucher.frame.width, height: CGFloat.greatestFiniteMagnitude)
                let expectedSize = textVoucher.sizeThatFits(maxSize)
                var newFrame = textVoucher.frame
                newFrame.size.height = expectedSize.height
                textVoucher.frame = newFrame
            }
            
            self.lbl_company.text? = Ads![cmpId].companyname!.uppercased()
            AF.request((Ads?[cmpId].logo)!).responseImage { [self] response in
                switch response.result {
                case .success(let image):
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: self.voucherImage.frame.width * 0.88, y: self.voucherImage.frame.height * 1.13, width: self.voucherImage.frame.width * 0.13, height: self.voucherImage.frame.width * 0.13 * 0.64)
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 8
                    imageView.layer.masksToBounds = true
                    imageView.clipsToBounds = true
                    imageView.tag = 102
                    self.view.addSubview(imageView)
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }

        startTextLabel.frame.origin.x = lbl_company.frame.origin.x
        imgArrow.frame.origin.x = lbl_company.frame.origin.x
        startTextLabel.frame.origin.y = voucherImage.frame.origin.y + voucherImage.frame.height + 20
        let newSize = self.startTextLabel.sizeThatFits(CGSize(width: self.startTextLabel.frame.width, height: 100))
        fldDistance.frame.origin.x = imgArrow.frame.size.width + 20
        fldDistance.frame.origin.y = startTextLabel.frame.origin.y + newSize.height + 18
        imgArrow.frame.origin.y = fldDistance.frame.origin.y + 4
        
        NSLayoutConstraint.activate([
            textVoucher.topAnchor.constraint(equalTo: fldDistance.bottomAnchor, constant: 10),
            textVoucher.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textVoucher.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
       ])
    }
    
    func smallestDistance(adOutlets: [AdOutlet]?) -> String {
        guard let outlets = adOutlets, !outlets.isEmpty else {
            return ""
        }
        let distances = outlets.compactMap { $0.distance }
        if let smallestDistance = distances.min() {
            imgArrow.isHidden = false
            if smallestDistance >= 1 {
                let roundedDistance = String(format: "%.2f", smallestDistance) // Round to two decimal places
                return "\(roundedDistance) km"
            } else {
                let meters = Int(smallestDistance * 1000)
                return "\(meters) meter"
            }
        } else {
            return ""
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
//        let URL_AD = Ads?[cmpId].calltoactionresource
//        let activityController = UIActivityViewController(activityItems: [URL_AD as Any], applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
    
        let urlString = (Ads?[cmpId].calltoactionresource)!

        // Ensure the URL is correctly percent-encoded in UTF-8
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL")
        }

        
    }
    
    func base64Encode(_ data: String) -> String? {
        guard let encodedData = data.data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        return encodedData
    }
    
    @IBAction func btnFollow(_ sender: Any) {
        if Ads![cmpId].following == 1 {
            let image2 = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            follow.setImage(image2, for: .normal)
            Ads?[cmpId].following = 0
        } else {
            c_api.patchrequest(company: String(Ads![cmpId].id), key: "stat", action: "11") {}
            let image2 = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            follow.setImage(image2, for: .normal)
            Ads?[cmpId].following = 1
        }
        let userchannel = userChannel
        c_api.patchrequest(company: String(Ads![cmpId].companyid!), key: "following", action: "") {
            let params = "/"+userchannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
            c_api.getrequest(params: params, key: "getuser") {
            }
        }
    }
    
    func ButtonCss() {
        
        if Ads?[cmpId].outlets != nil {
            map.isEnabled = true
        } else {
            map.isEnabled = false
        }
        let myColour = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)
        map.layer.cornerRadius = 6
        map.layer.borderWidth = 1
        map.layer.borderColor = myColour.cgColor
        map.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "map.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        map.setImage(image3, for: .normal)
        map.imageView?.contentMode = .scaleAspectFit
        
        Nettside.layer.cornerRadius = 6
        Nettside.layer.borderWidth = 1
        Nettside.layer.borderColor = myColour.cgColor
        Nettside.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)

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
        
        let myColour2 = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
        btnHome.frame.size.width = btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "house.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image1, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        btnBack.frame.size.width = btnBack.frame.height
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
        let string1 = String(Ads![cmpId].id)
        let string2 = String(myuser.username)
        let orgIdString = String(string1).trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameString = String(string2).trimmingCharacters(in: .whitespacesAndNewlines)
        let encodedOrgIdString = orgIdString.data(using: .utf8)?.base64EncodedString() ?? ""
        let encodedUsernameString = usernameString.data(using: .utf8)?.base64EncodedString() ?? ""
        let urlString = "https://share50.no/sharedad/" + encodedOrgIdString + "/" + encodedUsernameString
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL")
        }
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
       if cmpId < (Ads!.count - 1) {
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

extension UILabel {
    private var bottomBorderLayer: CALayer? {
        return layer.sublayers?.first { $0.name == "bottomBorder" }
    }
    func addBottomBorder() {
        removeBottomBorder() // Remove existing border if any

        let border = CALayer()
        border.name = "bottomBorder"
        border.borderColor = UIColor.darkGray.cgColor
        border.borderWidth = 1
        layer.addSublayer(border)
        layer.masksToBounds = true
        let newSize = sizeThatFits(CGSize(width: frame.width, height: 100))
        frame.size.height = newSize.height + 15
        border.frame = CGRect(x: 0, y: newSize.height + 14, width: frame.size.width, height: 1)
    }
    func removeBottomBorder() {
        bottomBorderLayer?.removeFromSuperlayer()
    }
}

