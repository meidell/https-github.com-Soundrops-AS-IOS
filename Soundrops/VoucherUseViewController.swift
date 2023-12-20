import UIKit

class VoucherUseViewController: UIViewController {

    var window: UIWindow?
    
    @IBOutlet weak var lbl_code: UILabel!
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var img_border_bottom: UIImageView!
    @IBOutlet weak var img_border_top: UIImageView!
    @IBOutlet weak var lblcompany: UILabel!
    @IBOutlet weak var lbl_voucher: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "uservoucher_to_voucher_segue", sender: self)
    }
    
    @IBAction func btn_copy_code(_ sender: Any) {
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        
        btnConfirm.layer.borderColor = UIColor.lightGray.cgColor
        btnConfirm.layer.borderWidth = 1

        
        if btnConfirm.titleLabel?.text == "Confirm" {
            btnConfirm.setTitle("Goto website", for: .normal)
            lbl_code.text = d_cmp[d_cmp["single"]!+d_me["mode"]!+":sd_cmp_voucher_code"]

            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.lbl_voucher.alpha = 0.0
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, animations: {
                self.lbl_voucher.alpha = 1.0
            }, completion: nil)
            
            let key = d_cmp["single"]!+d_me["mode"]!
            let urlString1:String = "https://webservice.soundrops.com/REST_set_user_protocol/"+d_me["sd_user_id"]!+"/"+d_cmp[key+":sd_cmp_id"]!+"/2/0"
            var myrequest = URLRequest(url: URL(string:urlString1)!)
            myrequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: myrequest) { data, response, error in
                guard let _ = data, error == nil else {
                    return
                }
            }
            task.resume()
            
            let urlString2:String = "https://webservice.soundrops.com/V1/USE_VOUCHER/"+d_cmp[key+":sd_cmp_id"]!+"/"+d_me["sd_user_id"]!
             var myrequest1 = URLRequest(url: URL(string:urlString2)!)
             myrequest1.httpMethod = "GET"
             let task1 = URLSession.shared.dataTask(with: myrequest1) { data, response, error in
             guard let _ = data, error == nil else {
                return
                }
             }
             task1.resume()
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let myColour2 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        img_border_bottom.layer.borderColor = myColour2.cgColor
        img_border_bottom.layer.borderColor = UIColor.white.cgColor
        img_border_bottom.layer.shadowColor =  UIColor.gray.cgColor
        img_border_bottom.layer.shadowOpacity = 0.8
        img_border_bottom.layer.shadowRadius = 1.5
        img_border_bottom.layer.borderWidth = 1
        img_border_bottom.layer.shadowOffset = CGSize(width: 0, height: 1)
        img_border_bottom.layer.cornerRadius = 15.0
        
        if #available(iOS 11.0, *) {
            img_border_bottom.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        img_border_top.layer.borderColor = myColour2.cgColor
        img_border_top.layer.borderColor = UIColor.white.cgColor
        img_border_top.layer.shadowColor =  UIColor.gray.cgColor
        img_border_top.layer.shadowOpacity = 0.8
        img_border_top.layer.shadowRadius = 1.5
        img_border_top.layer.shadowOffset = CGSize(width: 0, height: 1)
        img_border_top.layer.cornerRadius = 15.0
        img_border_top.layer.borderWidth = 1
        
        if #available(iOS 11.0, *) {
            img_border_bottom.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        lbl_voucher.layer.borderColor = myColour2.cgColor
        lbl_voucher.layer.borderColor = UIColor.white.cgColor
        lbl_voucher.layer.shadowColor =  UIColor.gray.cgColor
        lbl_voucher.layer.shadowOpacity = 0.8
        lbl_voucher.layer.shadowRadius = 1.5
        lbl_voucher.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        btnConfirm.layer.cornerRadius = 0
        btnConfirm.layer.borderColor = UIColor.lightGray.cgColor
        btnConfirm.layer.borderWidth = 1
        
//        lblcompany.text = company_name

    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let trans = CATransition()
            trans.type = CATransitionType.push
            trans.subtype = CATransitionSubtype.fromTop
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "voucher_use_to_dasboard_segue", sender: self)
            
        }
    }
    

}
