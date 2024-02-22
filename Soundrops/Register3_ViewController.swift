import UIKit
import CoreData
import Alamofire
import PushNotifications


class Register3_ViewController: UIViewController {
    
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var txtTerms_content: UITextView!
    
    @IBAction func btnPolicy(_ sender: Any) {
        guard let url = URL(string: "https://www.share50.no/policy") else {
            return
          }
          UIApplication.shared.open(url)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btn_continue.layer.cornerRadius = 5.0
        btn_continue.layer.borderColor = myColour2.cgColor
        btn_continue.layer.borderWidth = 1
        btn_continue.backgroundColor = UIColor.red
        btn_continue.titleLabel?.textColor = UIColor.white
        
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Continue", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btn_continue.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        
        let userchannel = userChannel
        let params = "/"+userchannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        c_api.postrequest(params: "", key: "updateuser") {
            c_api.getrequest(params: params, key: "getuser") {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        c_api.getrequest(params: "", key: "getperk") {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.performSegue(withIdentifier: "register3_to_dashboard_segue", sender: self)
        }
    }
}
