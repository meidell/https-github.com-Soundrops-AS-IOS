import UIKit
import Alamofire


class Register_1_ViewController: UITableViewController {
    
    let URL_GET_DATA = "http://webservice.soundrops.com/V1/Organisation/1"
    var organisations = [String]()
    var idOrganisations = [Int]()
    var myword: String = ""
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(URL_GET_DATA).responseJSON { response in
            if let json = response.result.value {
                let myArray: NSArray = json as! NSArray
                self.organisations.append("Select community")
                self.idOrganisations.append(0)
                for i in 0..<myArray.count {
                    self.myword = (myArray[i] as AnyObject).value(forKey: "Name")! as! String
                    print(self.myword)
                    self.organisations.append(((myArray[i] as AnyObject).value(forKey: "Name") as? String)!)
                    self.idOrganisations.append(((myArray[i] as AnyObject).value(forKey: "ID") as? Int)!)
                }
            }
  
        }
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = 50
        
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organisations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! MyCell
        myCell.nameLabel.text = organisations[indexPath.row]
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")!
    }
    

}

class Header: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My header"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        
    }
    
}

class MyCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hei der"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("select", for: .normal)
        return button
    }()
    
    let myImage: UIImageView = {
        
        var thisimage : UIImage = UIImage(named:"green_icon")!
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = thisimage
        return imageview
    }()
    
    
    func setupViews() {
        
        addSubview(nameLabel)
        addSubview(actionButton)
        addSubview(imageView!)
        
        actionButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":actionButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":actionButton]))
        
    }
    
    @objc func buttonAction(_ sender:UIButton) {
         print("tapped")
    }
    
}
