import UIKit
import SwiftyJSON
import Alamofire
import UserNotifications
import CoreData
import AuthenticationServices

class Start1_ViewController: UIViewController {
    
    var mynotification: String = "0"
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let signInButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(self.didTapSignIn(_:)), for: .touchUpInside)
        c_wifi.checkandGetLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        signInButton.center.x = self.view.center.x
        signInButton.center.y=self.view.frame.size.height*0.85
    }
    
    @objc func didTapSignIn(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension Start1_ViewController: ASAuthorizationControllerDelegate {
    
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }
      return payload
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?
            ASAuthorizationAppleIDCredential {
            userToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
            if let fullName = appleIDCredential.fullName {
                if fullName.givenName != "" {myuser.username = fullName.givenName ?? ""}
            }
            
            let millisecondsSince1970 = Int64(Date().timeIntervalSince1970 * 1000)
            let millisecondsString = String(millisecondsSince1970)
            let channel = randomAlphaNumericString(length: 10)+millisecondsString
            userChannel = channel
            if isConnectedtoNotifications {mynotification="1"}
            let answer = c_api.setappleuser(name: myuser.username, notification: mynotification, token:userToken,channel: userChannel)
            if myuser.userprofile == 0 {
                c_api.getrequest(params: "", key: "gettopten") {}
                self.performSegue(withIdentifier: "start1_to_startafter", sender: self)
        
            } else  {
                //ny kode
                let params = "/"+userChannel+"/"+String(myuser.userlat)+"/"+String(myuser.userlon)
                c_api.getrequest(params: "", key: "gettopten") {
                    c_api.getrequest(params: "", key: "getperk") {
                        c_api.getrequest(params: params, key: "getuser") {
                            DispatchQueue.main.async {
                                if userBadRequest {
                                    let alertController = UIAlertController(title: "Feil", message: "Opps. Dette er vår feil. Stop og start appen på nytt.", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
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
                                } else {
                                    self.performSegue(withIdentifier: "start_to_dashboard_segue", sender: self)
                                }
                               
                            }
                        }
                    }
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
    
    }

extension Start1_ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}



