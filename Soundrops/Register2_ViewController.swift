import UIKit
import KeychainSwift
import CoreLocation
import PushNotifications
import Alamofire
import CoreData
import AlamofireImage

class Register2_ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    var age = [Int](15...80)
    var ageString = [String]()
    var bChanged = false
    var bGood = false
    lazy var geocoder = CLGeocoder()

    @IBOutlet weak var fld_organisasjon: UITextField!
    @IBOutlet weak var fld_name: UITextField!
    @IBOutlet weak var fld_postal_code: UITextField!
    @IBOutlet weak var btn_female: UIButton!
    @IBOutlet weak var btn_male: UIButton!
    @IBOutlet weak var pck_age: UIPickerView!
    @IBOutlet weak var btn_continue: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fld_name.addTarget(self, action: #selector(fldName), for: .editingChanged)
        fld_postal_code.addTarget(self, action: #selector(fldPostalCode), for: .editingChanged)
        fld_postal_code.keyboardType = .numberPad
        ageString = age.map { String($0) }
        ageString.insert("-", at: 0)
        
        run(after: 1) {
            let location = CLLocation(latitude: myuser.userlat, longitude: myuser.userlon)
        }
        
        let myColour = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        if myuser.usergender == 2 {
            btn_female.backgroundColor = myColour
            btn_male.backgroundColor = UIColor.white
            btn_female.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn_male.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        }
        if myuser.usergender  == 1 {
            btn_male.backgroundColor = myColour
            btn_female.backgroundColor = UIColor.white
            btn_male.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn_female.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        }
        
        fld_name.text = myuser.username.uppercased().replacingOccurrences(of: "_", with: " ")
        fld_postal_code.text = myuser.userhometown.uppercased()
        fld_organisasjon.text = myorg.orgname.uppercased()
        
        var thisAge = myuser.userage
        if myuser.userage > 15 {
            thisAge = myuser.userage-14
            pck_age.selectRow(thisAge, inComponent: 0, animated: false)
        }
        
        btn_continue.backgroundColor = UIColor.red
        btn_continue.titleLabel?.textColor = UIColor.white
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        fld_organisasjon.layer.cornerRadius = 5.0
        fld_organisasjon.layer.borderColor = myColour2.cgColor
        fld_organisasjon.layer.borderWidth = 1
        
        fld_name.layer.cornerRadius = 5.0
        fld_name.layer.borderColor = myColour2.cgColor
        fld_name.layer.borderWidth = 1
        
        fld_postal_code.layer.cornerRadius = 5.0
        fld_postal_code.layer.borderColor = myColour2.cgColor
        fld_postal_code.layer.borderWidth = 1
        
        btn_female.layer.cornerRadius = 5.0
        btn_female.layer.borderColor = myColour2.cgColor
        btn_female.layer.borderWidth = 1
        
        btn_male.layer.cornerRadius = 5.0
        btn_male.layer.borderColor = myColour2.cgColor
        btn_male.layer.borderWidth = 1
        
        btn_continue.layer.cornerRadius = 5.0
        btn_continue.layer.borderColor = myColour2.cgColor
        btn_continue.layer.borderWidth = 1
        
        let attributedString = NSAttributedString(
          string: NSLocalizedString("Fortsett", comment: ""),
          attributes:[
            NSAttributedString.Key.underlineStyle:0
          ])
        btn_continue.setAttributedTitle(attributedString, for: .normal)

        pck_age.layer.cornerRadius = 5.0
        pck_age.layer.borderColor = myColour2.cgColor
        pck_age.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(Register2_ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Register2_ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        checkChange()

    }
    
    @IBAction func fldthat(_ sender: Any) {
        performSegue(withIdentifier: "register2_to_register1_segue", sender: self)
    }
    
    
    @IBAction func fldPostalCode(_ sender: Any) {

        if fld_postal_code.text!.count > 4 {
            fld_postal_code.text = ""
        }
        
        if fld_postal_code.text!.count == 0 {
            myuser.userhometown = ""
        }

        if fld_postal_code.text?.count == 4 && fld_postal_code.text?.isNumber == true {
            let group = DispatchGroup()
            group.enter()
            myuser.userpostcode = fld_postal_code.text!
            c_api.getrequest(params: "/" + fld_postal_code.text!, key: "getpostcode") {
                group.leave()
            }
            group.notify(queue: .main) {
                
                if myuser.userhometown != "" {
                    self.fld_postal_code.text = myuser.userhometown
                    self.fld_postal_code.resignFirstResponder()
                    self.checkChange()
                } else {
                    self.fld_postal_code.text = ""
                    self.fld_postal_code.resignFirstResponder()
                    self.checkChange()
                    
                    let alertController = UIAlertController(title: "Feil", message: "Postkoden eksisterer ikke", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.fld_postal_code.becomeFirstResponder()
                    }
                    alertController.addAction(okAction)
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = scene.windows.first,
                       let topController = window.rootViewController {
                        
                        var topPresentedController = topController
                        while let presentedController = topPresentedController.presentedViewController {
                            topPresentedController = presentedController
                        }
                        
                        topPresentedController.present(alertController, animated: true, completion: nil)
                    }
                }

            }
        }
        checkChange()
    }

    
    @objc func fldName(textField: UITextField) {
        myuser.username = fld_name.text!
        checkChange()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
    
    func checkChange() {
        if myuser.userage>0 && myuser.username != "" && myuser.userhometown != "" && myuser.usergender > 0 && myuser.userlat > 0 && myuser.userlon > 0 {
            bGood = true
//            btn_continue.backgroundColor = UIColor.red
//            btn_continue.titleLabel?.textColor = UIColor.white
        } else {
            bGood = false
//            btn_continue.backgroundColor = UIColor.white
//            btn_continue.titleLabel?.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        if bGood {
            if userChannel == "" || myuser.userprofile == 0 {
                performSegue(withIdentifier: "register2_register3", sender: self)
            } else {
                let userchannel = userChannel
                c_api.postrequest(params: "", key: "updateuser") {
                    let params = "/"+userchannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
                    c_api.getrequest(params: params, key: "getuser") {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "register2_to_dashboard_segue", sender: self)
                        }

                    }
                }
            }

        } else {
            
            var resultString = ""

            if myuser.userage<1  {
                resultString += "\n Alder"
            }
            if myuser.username == "" {
                resultString += "\n Brukernavn"
            }
            if myuser.userhometown == "" {
                resultString += "\n Postnummer"
            }
            if myuser.usergender < 1 {
                resultString += "\n Kjønn"
            }

            let alertController = UIAlertController(title: "Fyll inn:",
                                                    message: resultString,
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    

    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    @IBAction func btnFemale(_ sender: Any) {
        fld_name.resignFirstResponder()
        let myColour = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        btn_female.backgroundColor = myColour
        btn_male.backgroundColor = UIColor.white
        btn_female.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn_male.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        myuser.usergender = 2
        checkChange()
    }

    @IBAction func btnMale(_ sender: Any) {
        fld_name.resignFirstResponder()
        btn_male.backgroundColor = UIColor.red
        btn_female.backgroundColor = UIColor.white
        btn_male.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn_female.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        myuser.usergender = 1
        checkChange()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        return String(ageString[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fld_name.resignFirstResponder()
        myuser.userage = Int(ageString[row])!
        checkChange()
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fld_name.resignFirstResponder()
        return true
    }
    
  
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Lokasjon er slått av",
                                                message: "Skru på lokalisering for å logge på.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Åpne preferanser", style: .default) { (action) in
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

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
