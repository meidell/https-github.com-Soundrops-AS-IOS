import UIKit
import Alamofire
import AlamofireImage
import PushNotifications
import CoreData

class Register1_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var btn_info: UIButton!
    @IBOutlet weak var img_search: UIImageView!
    @IBOutlet weak var img_magnifying_glass: UIImageView!
    @IBOutlet weak var fld_search: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func btnInfo(_ sender: Any) {
        
        let alert = UIAlertController(title: "New organizations", message: "New organisations are registered on an ongoing basis. In the meantime, please choose the Share//50 Community Fund. As soon as your favorite organisation is registered you can switch by accessing your profile. Your new organisation will be forwarded your temporarily established funds on the day of transfer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                      
        fld_search.delegate = self
        fld_search.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        fld_search.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        img_search.backgroundColor = UIColor.white
        img_search.layer.borderWidth = 1
        img_search.layer.borderColor = myColour2.cgColor
        img_search.layer.cornerRadius = 5
               
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Organisations?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! Register1_TableViewCell
        cell.lbl_name.text = Organisations?[indexPath.row].orgname!.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myint =  indexPath.row
        myorg.orgname = Organisations?[myint].orgname ?? ""
        myuser.userorg = Organisations?[myint].orgid ?? 0
        self.performSegue(withIdentifier: "register1_register2", sender: self)
    }
    
    @objc func myTargetFunction() {
        img_magnifying_glass.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let sSearch = fld_search.text ?? ""
        let group = DispatchGroup()
        group.enter()
        c_api.getrequest(params: "/"+sSearch, key: "getorganisations") {
            group.leave()
        }
        group.notify(queue: .main) {
            self.tableview.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fld_search.resignFirstResponder()
        self.tableview.reloadData()
        return true
    }
}
