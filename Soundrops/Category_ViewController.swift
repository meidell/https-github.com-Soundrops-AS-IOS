import UIKit
import Alamofire

class Category_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var didScroll:Bool = false
    var categories = [Int: String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourites: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        tableView.dataSource = self
        tableView.delegate = self
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        self.tableView.reloadData()
        
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "house.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image1, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        btnFavourites.frame.size.width=btnFavourites.frame.height
        btnFavourites.backgroundColor = .white
        btnFavourites.layer.cornerRadius = btnFavourites.frame.width / 2
        btnFavourites.layer.borderWidth = 1
        btnFavourites.layer.borderColor = myColour2.cgColor
        btnFavourites.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        if didScroll == false {
            let image2 = UIImage(systemName: "heart.fill", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            btnFavourites.imageView?.contentMode = .scaleAspectFit
        } else {
            let image2 = UIImage(systemName: "heart.fill", withConfiguration: largeConfig2)?.withTintColor(.red, renderingMode: .alwaysOriginal)
            btnFavourites.setImage(image2, for: .normal)
            btnFavourites.imageView?.contentMode = .scaleAspectFit
        }
        didScroll=false

        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour2.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig3 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image3 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig3)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image3, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "showCategoryinForme", sender: self)
    }
    
    @IBAction func btnFavourites(_ sender: Any) {
        switch g_mod {
        case "follow":
            g_mod=g_omd
        default:
            g_omd=g_mod
            g_mod="follow"
        }
        performSegue(withIdentifier: "showCategoryinForme", sender: self)
    }
    
    @IBAction func btnHome(_ sender: Any) {
        performSegue(withIdentifier: "category_to_dashboard", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
           if translation.y > 0 {
               // swipes from top to bottom of screen -> down
               UIView.animate(withDuration: 0.1, delay: 0, animations: {
                   self.btnHome.alpha = 1
                   self.btnBack.alpha = 1
                   self.btnFavourites.alpha = 1
               }, completion: nil)
           } else {
               // swipes from bottom to top of screen -> up
               if didScroll == true {
                   UIView.animate(withDuration: 0.5, delay: 0, animations: {
                       self.btnHome.alpha = 0
                       self.btnBack.alpha = 0
                       self.btnFavourites.alpha = 0
                   }, completion: nil)
               }
               didScroll = true
           }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sortedCategoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! Category_cell
        let category = sortedCategoryList[indexPath.row]
        cell.lbl_Category.text = category.key
        cell.lbl_follow.text = "\(category.value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = sortedCategoryList[indexPath.row]
        userCategory = myCategory[selectedCategory.key]!
        cmptype = "category"
        performSegue(withIdentifier: "showCategoryinForme", sender: self)
    }
    
     func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let trans = CATransition()
            trans.type = CATransitionType.push
            trans.subtype = CATransitionSubtype.fromTop
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.25
            self.navigationController?.view.layer.add(trans, forKey: nil)
            self.performSegue(withIdentifier: "category_to_dashboard_segue", sender: self)
        }
    }
}
