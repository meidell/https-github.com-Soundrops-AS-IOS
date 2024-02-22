//
//  IdentifidationViewController.swift
//  
//
//  Created by Jan Erik Meidell on 21/11/2018.
//

import UIKit
import Alamofire

class Checkid_ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var btn_verify_code: UIButton!
    @IBOutlet weak var id_code: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    
    var identification_code: String = ""
    var feedBack: String = ""

    var window: UIWindow?

    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "checkid_to_profile1", sender: self)

    }
    @IBAction func btn_verify(_ sender: Any) {
        c_api.patchrequest(company: "", key: "pairphone", action: id_code.text ?? "") {
            self.showToast(message: "Token er sent. Vent for bekreftelse på notifikasjon.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Checkid_ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Checkid_ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
      //  id_code.text =  userChannel
        
        
        self.id_code.delegate = self
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        id_code.backgroundColor = UIColor.white
        id_code.layer.borderWidth = 1
        id_code.layer.borderColor = myColour2.cgColor
        id_code.layer.cornerRadius = 2.0
        id_code.layer.shadowColor = myColour2.cgColor
        id_code.layer.shadowOpacity = 0.5
        id_code.layer.shadowRadius = 1.2
        id_code.layer.shadowOffset = CGSize(width: 0, height: 2)
       
        let placeholderText = "Skrive inn token her."
               let attributes: [NSAttributedString.Key: Any] = [
                   .foregroundColor: UIColor.lightGray,   // Set the color you want
                   .font: UIFont.systemFont(ofSize: 20)  // Set the font size you want
               ]
        id_code.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)

        
        let myColour = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image3, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width*0.10, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width*0.8, height: 40))
        if self.feedBack == "no" {
              toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        else {
              toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
      
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "System", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
   
}
