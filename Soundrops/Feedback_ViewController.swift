//
//  Feedback_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 22.01.2024.
//  Copyright © 2024 Jan Erik Meidell. All rights reserved.
//
import UIKit

class Feedback_ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fldOrg: UITextField!
    @IBOutlet weak var fldText: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        let myColour1 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour1.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image4 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image4, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
        
        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        fldOrg.layer.cornerRadius = 5.0
        fldOrg.layer.borderColor = myColour2.cgColor
        fldOrg.layer.borderWidth = 1
        fldOrg.delegate = self

        
        fldText.layer.cornerRadius = 5.0
        fldText.layer.borderColor = myColour2.cgColor
        fldText.layer.borderWidth = 1
        fldText.delegate = self
        
        let padding: CGFloat = 15
        fldOrg?.setPadding(left: padding, right: padding)
        fldText?.setPadding(left: padding, right: padding)
        
        btnSend.backgroundColor = UIColor.red
        btnSend.titleLabel?.textColor = UIColor.white
        btnSend.layer.cornerRadius = 5.0
        btnSend.layer.borderColor = myColour2.cgColor
        btnSend.layer.borderWidth = 1
        btnSend.isEnabled = false
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle: 0,]
        let attributedTitle = NSAttributedString(string: "Send", attributes: attributes)
        btnSend.setAttributedTitle(attributedTitle, for: .normal)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    @IBAction func fldOrg(_ sender: Any) {
    }
    
    @IBAction func fldText(_ sender: Any) {

    }
    @IBAction func btnWeb(_ sender: Any) {
        if let url2 = URL(string: "https://www.share50.no/orgregshort#1") { UIApplication.shared.open(url2, options: [:])}
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          checkChange()
           return true
       }
    
    func checkChange() {
        
        if let org = fldOrg.text, org.count > 2,
           let text = fldText.text, text.count > 2 {
            btnSend.backgroundColor = UIColor.red
            btnSend.titleLabel?.textColor = UIColor.white
            btnSend.isEnabled = true
        } else {
            btnSend.backgroundColor = UIColor.white
            btnSend.titleLabel?.textColor = UIColor.lightGray
        }
    }
    
   
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "feedback_to_profile", sender: self)
    }
    
    @IBAction func btnSend(_ sender: Any) {
    
        mylead.name = fldOrg.text!
        mylead.comment = fldText.text!
        c_api.postrequest(params: "", key: "insertlead") {
        }
        self.fldOrg.text = ""
        self.fldText.text = ""
        self.btnSend.backgroundColor = UIColor.white
        self.btnSend.titleLabel?.textColor = UIColor.lightGray
        let alert = UIAlertController(title: "Informasjonen er blitt sendt.", message: "Takk for din input. Vi vil ta kontakt med din organisasjon i den nærmeste fremtid.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UITextField {
    func setPadding(left: CGFloat, right: CGFloat? = nil) {
        setLeftPadding(left)
        if let rightPadding = right {
            setRightPadding(rightPadding)
        }
    }

    private func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    private func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

