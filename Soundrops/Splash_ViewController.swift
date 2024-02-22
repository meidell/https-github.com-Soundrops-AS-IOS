import UIKit
import Alamofire
import AlamofireImage
import PushNotifications
import UserNotifications
import CoreData
import Network
import SwiftUI

class Splash_ViewController: UIViewController {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var img_sponsor: UIImageView!
    @IBOutlet weak var imgSupport: UIImageView!
    @IBOutlet weak var lbl_user_thanks: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        img_logo.isHidden=false
        if userChannel == "" {
           self.performSegue(withIdentifier: "Splash_Startbefore2", sender: self)

        } else {
            let userchannel = userChannel
            if isConnectedtoWifi {
                c_wifi.checkandGetLocation()
            }
            let params = "/"+userchannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
            c_api.getrequest(params: "", key: "gettopten") {
                c_api.getrequest(params: "", key: "getperk") {
                    c_api.getrequest(params: "", key: "getcompetition") {
                        c_api.getrequest(params: params, key: "getuser") {
                            DispatchQueue.main.async {
                                if userBadRequest {
                                    self.performSegue(withIdentifier: "Splash_Startbefore2", sender: self)
                                } else {
                                    if myuser.userprofile == 0 {
                                        self.performSegue(withIdentifier: "splash_to_register1", sender: self)
                                    } else {
                                        if let wsyc = wsyc {
                                            AF.request(wsyc.logostream).responseImage { response in
                                                switch response.result {
                                                case .success(let image):
                                                    self.img_sponsor.image = image
                                                case .failure(let error):
                                                    print("Error loading image: \(error)")
                                                }
                                                self.wsync()
                                            }
                                        }
                                    }
                                }
                               
                            }
                        }
                    }
                }
            }
        }
    }
    
    func wsync() {
        self.img_logo.isHidden=false
        self.lbl_user_thanks.text="Takk "+myuser.username+" for at du støtter din organisasjon."
        self.imgSupport.isHidden=false
        c_api.patchrequest(company: String(0), key: "stat", action: "17") {
        }
      //  self.lbl_user_thanks.text = touched + " " + test + " " + String(cmpId) + " seque_splash_to_detail " + startedWithNotification
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if startedWithNotification == "yes" && cmpId > 0 {
              //  cmptype = "notification"
                self.performSegue(withIdentifier: "seque_splash_to_detail", sender: self)
            } else {
                self.sven()
            }
        }
    }
    
    func sven() {
        if startedWithNotification == "no" {
            self.performSegue(withIdentifier: "splash_to_dashboard", sender: self)
        }
    }
}
