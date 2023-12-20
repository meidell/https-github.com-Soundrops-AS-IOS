import UIKit
import SwiftyJSON
import Alamofire
import UserNotifications
import CoreData
import AuthenticationServices

class Start1_ViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let signInButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(self.didTapSignIn(_:)), for: .touchUpInside)
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
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            userToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
            
            if let fullName = appleIDCredential.fullName {
                    let firstName = fullName.givenName
                myuser.username = firstName ?? ""
                }
            let response = c_api.setappleuser(name: myuser.username, notification: userNotification, token:userToken,channel: userChannel)
            if response == "new" || myuser.userprofile == 0 {
                    self.performSegue(withIdentifier: "start_to_registration_segue", sender: self)
                   
                } else  {
                    self.performSegue(withIdentifier: "start_to_dashboard_segue", sender: self)
                }
            }
        }
    }


extension Start1_ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}



