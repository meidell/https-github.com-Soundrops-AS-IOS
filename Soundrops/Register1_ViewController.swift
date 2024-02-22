import UIKit
import Alamofire
import AlamofireImage
import PushNotifications
import CoreData

class Register1_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var img_search: UIImageView!
    @IBOutlet weak var fld_search: UITextField!
    @IBOutlet weak var tableview: UITableView!
  
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBAction func btnInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "register1_to_feedback", sender: self)
    }
    
    var myHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myHeight = self.tableview.frame.size.height

        let myColour2 = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        self.img_search.backgroundColor = UIColor.white
        self.img_search.layer.borderWidth = 1
        self.img_search.layer.borderColor = myColour2.cgColor
        self.img_search.layer.cornerRadius = 5
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        c_api.getrequest(params: "", key: "getorganisations") {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.fld_search.delegate = self
            self.fld_search.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
            self.tableview.dataSource = self
            self.tableview.delegate = self
            self.tableview.reloadData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableview.frame.size.height = myHeight - keyboardSize.height * 0.8
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
            tableview.contentInset = contentInsets
            tableview.scrollIndicatorInsets = contentInsets
            tableview.frame.size.height = myHeight
    }
    
    func addnote() {
        
        // Create the white subview
               let whiteSubview = UIView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 300))
               whiteSubview.backgroundColor = .white
               whiteSubview.tag = 123
               self.view.addSubview(whiteSubview)
               
               // Add the title label
               let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: whiteSubview.frame.width, height: 40))
               titleLabel.text = "OBS"
               titleLabel.textColor = .black
               titleLabel.textAlignment = .center
               titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
               whiteSubview.addSubview(titleLabel)
               
               // Add the text label
               let textLabel = UILabel(frame: CGRect(x: 20, y: 70, width: whiteSubview.frame.width - 40, height: 200))
               textLabel.text = "Klubben din er ikke registrert ennå, men det var godt du oppdaget det! Vi jobber med å registrere alle klubber. Tips oss via appen og innstillinger/tannhjulet, så kontakter vi din klubb. Velg en annen klubb i mellomtiden og vi sørger for å få med klubben din i fremtiden!"
               textLabel.textColor = .black
               textLabel.textAlignment = .center
               textLabel.numberOfLines = 0 // Allow multiple lines
               whiteSubview.addSubview(textLabel)
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
        let getImage = Organisations?[indexPath.row].orglogo
        
        AF.request(getImage!).responseImage { [] response in
            switch response.result {
            case .success(let image):
                cell.imgLogo.image = image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myint =  indexPath.row
        let num = 1 + (Organisations?[myint].orgfollowers ?? 0)
        myorg.orgname = Organisations?[myint].orgname ?? ""
        myuser.userorg = Organisations?[myint].orgid ?? 0
        myorg.orglogo = Organisations?[myint].orglogo ?? ""
        myorg.orgfollowers = num
        myorg.orgrevenue = Organisations?[myint].orgrevenue ?? 0
                
        
        self.performSegue(withIdentifier: "register1_register2", sender: self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let sSearch = fld_search.text ?? ""
        let group = DispatchGroup()
        group.enter()
        c_api.getrequest(params: "/"+sSearch, key: "getorganisations") {
            group.leave()
        }
        group.notify(queue: .main) {
            if let subviewWithTag = self.view.viewWithTag(123) {
                subviewWithTag.removeFromSuperview()
            }
            self.tableview.reloadData()
            if Organisations?.count == 0 {
                self.addnote()
            }
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


