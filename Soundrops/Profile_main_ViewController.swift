import UIKit
import CoreData
import CoreLocation
import PushNotifications
import Alamofire
import AlamofireImage

class Profile_main_ViewController:  UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    var age = [Int](15...80)
    var ageString = [String]()
    var locationManager = CLLocationManager()
    var myDict: Dictionary = [String: String]()
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var btn_female: UIButton!
    @IBOutlet weak var btn_male: UIButton!
    @IBOutlet weak var lbl_organisation: UILabel!
    @IBOutlet weak var img_top_border: UIImageView!
    @IBOutlet weak var img_org: UIImageView!
    @IBOutlet weak var img_bottom_border: UIImageView!
    @IBOutlet weak var fld_name: UITextField!
    @IBOutlet weak var pck_age: UIPickerView!
    @IBOutlet weak var lbl_white_alpha: UILabel!
    @IBOutlet weak var btn_continue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        d_me["sd_country"] = locale.regionCode!
        ageString = age.map { String($0) }
        ageString.insert("-", at: 0)
        myDict["age"]=d_me["sd_age"]
        myDict["gender"]=d_me["sd_gender"]
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        run(after: 1) {
            let location = CLLocation(latitude: Double(d_me["sd_latitude"]!)!, longitude: Double(d_me["sd_longitude"]!)!)
            self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
               self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
        
        Alamofire.request(d_me["sd_org_image_logo"]!).responseImage { response in
            let image = response.result.value
            self.img_org.image = image
        }
        
        let myColour = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        if d_me["sd_gender"] == "2" {
            btn_female.backgroundColor = myColour
            btn_male.backgroundColor = UIColor.white
            btn_female.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn_male.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        }
        if d_me["sd_gender"]  == "1" {
            btn_male.backgroundColor = myColour
            btn_female.backgroundColor = UIColor.white
            btn_male.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn_female.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        }
      //  fld_name.text = d_me["sd_name"]!.uppercased()
      //  fld_name.delegate = self
     //   lbl_organisation.text = d_me["sd_org_name"]!.uppercased()

        NotificationCenter.default.addObserver(self, selector: #selector(Register2_ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Register2_ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if d_me["sd_age"] == nil || d_me["sd_age"] == "" {d_me["sd_age"] = "-"}
        var thisage = Int(d_me["sd_age"]!) ?? 10
        if thisage > 15 {
            thisage -= 14
            pck_age.selectRow(thisage, inComponent: 0, animated: false)
        }
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

    
        lbl_white_alpha.layer.borderWidth = 1
        lbl_white_alpha.layer.borderColor = myColour2.cgColor
        
        img_top_border.backgroundColor = UIColor.white
        img_top_border.layer.cornerRadius = 15.0
        img_top_border.layer.borderColor = UIColor.white.cgColor
        img_top_border.layer.borderWidth = 1
        img_top_border.layer.shadowColor =  UIColor.gray.cgColor
        img_top_border.layer.shadowOpacity = 0.8
        img_top_border.layer.shadowRadius = 1.5
        img_top_border.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        if #available(iOS 11.0, *) {img_top_border.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]}
        
        img_bottom_border.backgroundColor = UIColor.white
        img_bottom_border.layer.cornerRadius = 15.0
        img_bottom_border.layer.borderColor = UIColor.white.cgColor
        img_bottom_border.layer.borderWidth = 1
        img_bottom_border.layer.shadowColor =  UIColor.gray.cgColor
        img_bottom_border.layer.shadowOpacity = 0.8
        img_bottom_border.layer.shadowRadius = 1.5
        img_bottom_border.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        
        if #available(iOS 11.0, *) {img_bottom_border.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]}
        
        fld_name.layer.cornerRadius = 5.0
        fld_name.layer.borderColor = myColour2.cgColor
        fld_name.layer.borderWidth = 1
        
        btn_female.layer.cornerRadius = 5.0
        btn_female.layer.borderColor = myColour2.cgColor
        btn_female.layer.borderWidth = 1
        
        btn_male.layer.cornerRadius = 5.0
        btn_male.layer.borderColor = myColour2.cgColor
        btn_male.layer.borderWidth = 1
        
        btn_continue.layer.cornerRadius = 5.0
        btn_continue.layer.borderColor = myColour2.cgColor
        btn_continue.layer.borderWidth = 1
        
        pck_age.layer.cornerRadius = 5.0
        pck_age.layer.borderColor = myColour2.cgColor
        pck_age.layer.borderWidth = 1
        
    }
    
    @IBAction func btn_edit(_ sender: Any) {
    }
    @IBAction func btn_female(_ sender: Any) {
        fld_name.resignFirstResponder()
        let myColour = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        btn_female.backgroundColor = myColour
        btn_male.backgroundColor = UIColor.white
        btn_female.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn_male.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        d_me["sd_gender"]="2"
    }
    
    @IBAction func btn_male(_ sender: Any) {
        fld_name.resignFirstResponder()
        let myColour = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        btn_male.backgroundColor = myColour
        btn_female.backgroundColor = UIColor.white
        btn_male.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn_female.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        d_me["sd_gender"]="1"
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        if d_me["sd_name"] == "" {d_me["sd_name"]=fld_name.text}
        if (myDict["age"] != d_me["sd_age"] || myDict["gender"] != d_me["sd_gender"]) && d_me["sd_accept"]! == "true" {
            let alert = UIAlertController(title: "WARNING", message: "Altering gender or age will delete your history.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let replaced = d_me["sd_name"]!.replacingOccurrences(of: " ", with: "_")
                let myurl:String = "https://webservice.soundrops.com/REST_update_user/"+d_me["sd_user_id"]!+"/"+replaced+"/"+d_me["sd_gender"]!+"/"+d_me["sd_age"]!+"/"+d_me["sd_org_id"]!
                let encoded = myurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let url = URL(string: encoded!)
                Alamofire.request(url!).responseJSON { response in
                 //   if let json = response.result.value {
                       // let JSON = json as! NSDictionary
               //     }
                   self.loadorg()
                    self.performSegue(withIdentifier: "profile_main_to_dashboard", sender: self)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

            }))
            d_cmp["near:update"] = "yes"
            d_cmp["adds:update"] = "yes"
            self.present(alert, animated: true, completion: nil)

        } else {
            //upload user details to server
            if d_me["sd_accept"] == "true" {
                let replaced = d_me["sd_name"]!.replacingOccurrences(of: " ", with: "_")
                let myurl:String = "https://webservice.soundrops.com/REST_update_user/"+d_me["sd_user_id"]!+"/"+replaced+"/"+d_me["sd_gender"]!+"/"+d_me["sd_age"]!+"/"+d_me["sd_org_id"]!+"/"+d_me["sd_latitude"]!+"/"+d_me["sd_longitude"]!+"/"+d_me["sd_latitude"]!+"/"+d_me["sd_longitude"]!
                let encoded = myurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let url = URL(string: encoded!)
                Alamofire.request(url!).responseJSON { response in
                    if let json = response.result.value {
                     //   let JSON = json as! NSDictionary
                    }
                    self.loadorg()
                }
            }
            let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    data.setValue(d_me["sd_user_id"]!, forKey: "channel")
                    do {
                        try context.save()
                    } catch {
                    }
                }
            } catch {
            }
            if (d_me["sd_age"] != "-" && d_me["sd_age"] != "0" ) && (d_me["sd_gender"] != "") && (d_me["sd_name"] != "" && d_me["sd_name"] != "Select community" ) && d_me["sd_user_id"] != "" {
                if d_me["sd_accept"] == "false" {
                    if d_me["sd_login_method"] == "local" {
                        performSegue(withIdentifier: "register2_to_register2b_segue", sender: self)
                    } else {
                        performSegue(withIdentifier: "register2_to_register3_segue", sender: self)
                    }
                } else {
                    performSegue(withIdentifier: "profile_main_to_dashboard", sender: self)
                }
            } else {
                let alertController = UIAlertController(title: "Missing info", message:
                    "Please enter your name, age, and gender", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func loadorg() {
        
        let urlString1:String = "https://webservice.soundrops.com/REST_get_user_data/"+d_me["sd_user_id"]!
        let encoded = urlString1.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)
        Alamofire.request(url!).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                let val : NSObject = JSON["data_result"] as! NSObject;
                if !(val.isEqual(NSNull())) {
                    let JSON1 = JSON["data_result"] as! NSDictionary
                    d_me["sd_org_id"] = String(JSON1["sd_user_org"] as! Int)
                    d_me["sd_org_name"] = String(JSON1["sd_org_name"] as! String)
                    d_me["sd_org_id"] = String(JSON1["sd_org_id"] as! Int)
                    d_me["sd_org_description"] = String(JSON1["sd_org_description"] as! String)
                    d_me["sd_org_image_logo"] = String(JSON1["sd_org_image_logo"] as! String)
                    d_me["sd_org_image"] = String(JSON1["sd_org_image"] as! String)
                    d_me["sd_org_number_followers"] = String(JSON1["sd_org_number_followers"] as! String)
                    d_me["sd_org_funds_raised"] = String(JSON1["sd_org_funds_raised"]! as! Double)
                    d_me["sd_user_active"] = String(JSON1["sd_user_active"]! as! Bool)
                }
            }
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fld_name.resignFirstResponder()
        d_me["sd_age"] = ageString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.text = ageString[row]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
        
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
  
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                if placemark.postalCode != nil {
                    d_me["sd_country"] = placemark.isoCountryCode!
                }
            }
        }
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fld_name.resignFirstResponder()
        return true
    }
    
    
    
    // functions for location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            d_me["sd_latitude"] = String(location.coordinate.latitude)
            d_me["sd_longitude"] = String(location.coordinate.longitude)
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to sign in we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
