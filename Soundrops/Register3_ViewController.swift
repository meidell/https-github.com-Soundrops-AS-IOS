import UIKit
import CoreData
import Alamofire
import PushNotifications


class Register3_ViewController: UIViewController {
    
    @IBOutlet weak var btn_continue: UIButton!
    
    @IBOutlet weak var txtTerms_content: UITextView!
    @IBOutlet weak var txtTerms: UITextView!
    @IBAction func btnPolicy(_ sender: Any) {
        let myurl = "https://webservice.soundrops.com/REST_get_terms/1"
        let headers = [
              "Authorization": "",
              "auth_user": "user",
              "auth_pass": "pass"
          ]
        Alamofire.request(myurl, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                let JSON1 = JSON["data_result"] as! NSDictionary
                self.txtTerms.text = JSON1["sd_term_headline"] as? String
                self.txtTerms_content.text = JSON1["sd_term_content"] as? String
            }
        }
    }
    @IBAction func btnTerms(_ sender: Any) {
        let myurl = "https://webservice.soundrops.com/REST_get_terms/1"
        let headers = [
              "Authorization": "",
              "auth_user": "user",
              "auth_pass": "pass"
          ]
        Alamofire.request(myurl, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                let JSON1 = JSON["data_result"] as! NSDictionary
                self.txtTerms.text = JSON1["sd_term_headline"] as? String
                self.txtTerms_content.text = JSON1["sd_term_content"] as? String
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTerms.isEditable = false
        txtTerms_content.isEditable = false

        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btn_continue.layer.cornerRadius = 5.0
        btn_continue.layer.borderColor = myColour2.cgColor
        btn_continue.layer.borderWidth = 1
        
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Continue", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btn_continue.setAttributedTitle(attributedString, for: .normal)

    }
    
    @IBAction func btn_continue(_ sender: Any) {
        self.performSegue(withIdentifier: "register3_to_dashboard_segue", sender: self)
    }
}
