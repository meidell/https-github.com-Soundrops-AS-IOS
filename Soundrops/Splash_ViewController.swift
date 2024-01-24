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
    @IBOutlet weak var lbl_user_thanks: UILabel!
    
    override func viewDidLoad()  {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
     
        if !isConnectedtoWifi {
            let alert = UIAlertController(title: "Ingen internettforbindelse!", message: "Denne appen trenger internett for å kunne brukes. Koble deg til og prøv igjen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if myuser.userprofile == 1 {
            self.lbl_user_thanks.text="Velkommen "+myuser.username.uppercased()
            let params = "/"+userChannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
            c_api.getrequest(params: params, key: "getuser") {
                if let wsyc = wsyc {
                    Alamofire.request(wsyc.logostream).responseImage { response in
                        let image = response.result.value
                        self.img_sponsor.image = image
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                        self.performSegue(withIdentifier: "splash_to_dashboard", sender: self)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        myuser.userprofile = 0
                        self.performSegue(withIdentifier: "Splash_to_Start_1", sender: self)
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.performSegue(withIdentifier: "Splash_to_Start_1", sender: self)
            }
        }
        c_api.getrequest(params: "", key: "getperk") {
        }
        c_api.getrequest(params: "", key: "getmainimages") {
        }
        c_api.getrequest(params: "", key: "getorganisations") {
        }
    }
    
    func popupUpdateDialogue(){
        
        let alertMessage = "A new version of the Soundrops Application is available,Please update to version "+d_me["new_version"]!
        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/magento2-mobikul-mobile-app/id1166583793"),
               UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        let noBtn = UIAlertAction(title:"Skip" , style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(okBtn)
        alert.addAction(noBtn)
        //   self.present(alert, animated: true, completion: nil)
    }
    
}
