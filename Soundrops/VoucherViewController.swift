import UIKit
import Alamofire

class VoucherViewController: UIViewController {
    
    
    @IBOutlet weak var img_border_top: UIImageView!
    @IBOutlet weak var img_border_bottom: UIImageView!
    @IBOutlet weak var img_old_voucher: UIImageView!
    @IBOutlet weak var lbl_back_white: UILabel!
    @IBOutlet weak var lblcompany: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var myLogi: UIImageView!
    @IBOutlet weak var btnUseVoucher: UIButton!
    
    @IBAction func btnUseVoucher(_ sender: Any) {
         self.performSegue(withIdentifier: "voucher_to_usevoucher_segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        lblText.text = d_cmp[d_cmp["single"]!+d_me["mode"]!+":sd_cmp_voucher_desc"]
        lblTitle.text = d_cmp[d_cmp["single"]!+d_me["mode"]!+":sd_cmp_voucher_discount"]!+"\nVOUCHER"
        lblcompany.text = d_cmp[d_cmp["single"]!+d_me["mode"]!+":sd_company_name"]
        
        Alamofire.request(d_cmp[d_cmp["single"]!+d_me["mode"]!+":sd_company_logo"]!).responseImage { response in
            if let image = response.result.value {
                self.myLogi.image = image
            }
        }
        
        let myColour2 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        myLogi.layer.borderColor = myColour2.cgColor
        myLogi.layer.borderWidth = 3
        myLogi.backgroundColor = UIColor.white
        myLogi.layer.cornerRadius = 20.0
        //        logo.layer.masksToBounds = true
        myLogi.layer.shadowColor =  UIColor.gray.cgColor
        myLogi.layer.shadowOpacity = 0.2
        myLogi.layer.shadowRadius = 2
        myLogi.layer.shadowOffset = CGSize(width: 0, height: 2)
        if #available(iOS 11.0, *) {
            myLogi.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        }
        
        myLogi.frame.size.height = UIScreen.main.bounds.height*0.100445
        myLogi.frame.size.width = UIScreen.main.bounds.height*0.100445*1.222222
        
        
        img_border_top.layer.borderColor = myColour2.cgColor
        img_border_top.layer.borderColor = UIColor.white.cgColor
        img_border_top.layer.shadowColor =  UIColor.gray.cgColor
        img_border_top.layer.shadowOpacity = 0.8
        img_border_top.layer.shadowRadius = 1.5
        img_border_top.layer.shadowOffset = CGSize(width: 0, height: 1)
        img_border_top.layer.cornerRadius = 15.0
        img_border_top.layer.borderWidth = 1
        
        if #available(iOS 11.0, *) {
            img_border_top.layer.maskedCorners = [ .layerMinXMinYCorner , .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }

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
        
        img_old_voucher.layer.borderColor = myColour2.cgColor
        img_old_voucher.layer.borderColor = UIColor.white.cgColor
        img_old_voucher.layer.shadowColor =  UIColor.gray.cgColor
        img_old_voucher.layer.shadowOpacity = 0.8
        img_old_voucher.layer.shadowRadius = 1.5
        img_old_voucher.layer.shadowOffset = CGSize(width: 0, height: 1)
        
       
        btnUseVoucher.layer.cornerRadius = 0
        btnUseVoucher.layer.borderColor = UIColor.lightGray.cgColor
        btnUseVoucher.layer.borderWidth = 1
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let trans = CATransition()
            trans.type = CATransitionType.push
            trans.subtype = CATransitionSubtype.fromTop
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "voucher_to_dashboard_segue", sender: self)

        }
    }
}
