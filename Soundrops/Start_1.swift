import UIKit
import FBSDKLoginKit
import SwiftyJSON
import FBSDKCoreKit
import GoogleSignIn

class Start_1_ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var img_g: UIImageView!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var lbl_signin: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBAction func btnRegister(_ sender: Any) {
         self.performSegue(withIdentifier: "start_to_registration_segue", sender: self)
    }
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @objc func signinUserUsingGoogle(_ sender:UIButton) {
        if btn_signin.title(for: .normal) == "Sign out" {
            GIDSignIn.sharedInstance().signOut()
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? DashboardViewController {
            destinationViewController.mrefresh  = true
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        } else {

            let gplusapi = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken!)"
            let url = NSURL(string: gplusapi)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                do {
                    let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                    dict_me["gender"] = userData!["gender"] as? String
                    dict_me["name"] = userData!["name"] as? String
                    dict_me["email_user"] = userData!["email"] as? String
                } catch {
                    NSLog("Account Information could not be loaded")
                }
            }).resume()
            
            run(after: 1) {
                if let gmailuser = user {
                    self.btn_signin.setTitle("Sign out", for: .normal)
                    dict_me["name"] = gmailuser.profile.name
                    self.performSegue(withIdentifier: "start_to_registration_segue", sender: self)
                }
            }
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //successfull login
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func fetchProfile() {
        
        let parameters = ["fields": "name, email, gender, age_range"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {(connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let json = JSON(result!)
                dict_me["name"] = json["name"].stringValue
                dict_me["email_user"] = json["email"].stringValue
                dict_me["gender"] = json["gender"].stringValue
                print("my gender is: ",dict_me["gender"])
                self.performSegue(withIdentifier: "start_to_registration_segue", sender: self)
            }
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func buttonAction(sender: UIButton!) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_signin.addTarget(self, action: #selector(signinUserUsingGoogle(_:)), for: .touchUpInside)
        
        let myColour2 = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        btnRegister.layer.borderColor = myColour2.cgColor
        btnRegister.layer.borderWidth = 1
        btnRegister.layer.cornerRadius = 15.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        btnRegister.frame = CGRect(x: 0, y: 0, width:100, height: 44)
        btnRegister.center.x = UIScreen.main.bounds.width*0.35
        btnRegister.center.y = UIScreen.main.bounds.height*0.75
        
        if dict_me["name"] != "" {
           self.performSegue(withIdentifier: "start_to_dashboard_segue", sender: self)
        } else {
            
            let btnFBLogin = FBSDKLoginButton()
            btnFBLogin.readPermissions = ["public_profile"]
            btnFBLogin.delegate = self
            btnFBLogin.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.27, height: 44)
            btnFBLogin.center.x = UIScreen.main.bounds.width*0.65
            btnFBLogin.center.y = UIScreen.main.bounds.height*0.75
            btnFBLogin.layer.shadowColor = UIColor.lightGray.cgColor
            btnFBLogin.layer.shadowOpacity = 0.8
            btnFBLogin.layer.shadowRadius = 2
            btnFBLogin.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.view.addSubview(btnFBLogin)
            
            if FBSDKAccessToken.current() != nil{
                //allready logged in
                self.fetchProfile()
            }else{
                //not logged in
            }
            let myColour1 = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            let myColour2 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            
            self.btnRegister.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.25, height: 44)
            self.btnRegister.backgroundColor = UIColor.white
            self.btnRegister.center.x = UIScreen.main.bounds.width*0.35
            self.btnRegister.center.y = UIScreen.main.bounds.height*0.75
            self.btnRegister.layer.cornerRadius = 2.0
            self.btnRegister.layer.borderWidth = 1
            self.btnRegister.layer.borderColor = myColour2.cgColor
            self.btnRegister.layer.shadowColor = myColour1.cgColor
            self.btnRegister.layer.shadowOpacity = 0.8
            self.btnRegister.layer.shadowRadius = 2
            self.btnRegister.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.btn_signin.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.27, height: 44)
            self.btn_signin.backgroundColor = UIColor.white
            self.btn_signin.center.x = UIScreen.main.bounds.width*0.65
            self.btn_signin.center.y = UIScreen.main.bounds.height*0.82
            self.btn_signin.layer.cornerRadius = 2.0
            self.btn_signin.layer.borderWidth = 1
            self.btn_signin.layer.borderColor = myColour2.cgColor
            self.btn_signin.layer.shadowColor = myColour1.cgColor
            self.btn_signin.layer.shadowOpacity = 0.8
            self.btn_signin.layer.shadowRadius = 2
            self.btn_signin.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.img_g.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.03, height: UIScreen.main.bounds.width*0.03)
            self.img_g.backgroundColor = UIColor.white
            self.img_g.center.x = UIScreen.main.bounds.width*0.55
            self.img_g.center.y = UIScreen.main.bounds.height*0.82

        }
    }
}
