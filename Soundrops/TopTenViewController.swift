import UIKit
import Alamofire
import AlamofireImage

class TopTenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    var sortedTopTens: [Soundrops.TopTen] = []
    var didScroll:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(btnHome)
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        
        // Sort TopTens by earnings in descending order and limit to top 10
        sortedTopTens = Array((TopTens?.sorted(by: { ($0.earnings ?? 0) > ($1.earnings ?? 0) }).prefix(10)) ?? [])
        
        self.tableview.frame.origin.y = self.imageLogo.frame.maxY+10
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = UIColor.clear
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.reloadData()
        
        // Setup button appearance
        setupButton()
        
        didScroll=false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            // swipes from top to bottom of screen -> down
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.btnHome.alpha = 1
            }, completion: nil)
        } else {
            // swipes from bottom to top of screen -> up
            if didScroll == true {
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.btnHome.alpha = 0
                }, completion: nil)
            }
            didScroll = true
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "topten_dashboard", sender: self)
    }
    
    func setupButton() {
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnHome.frame.size.width = btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "house.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image1, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isMyOrgInTopTen = sortedTopTens.contains { $0.originalid == myorg.orgid }
        
        // If myorg.originalid is found in the top 10, we only need +1 for the empty row
        return sortedTopTens.count + (isMyOrgInTopTen ? 0 : 2)
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 10 {
            // Clear the background, borders, and content for the empty row
            cell.backgroundColor = UIColor.clear
            cell.backgroundView = nil
        } else {
            // Set the cell's background view to be a white box with a grey border for other rows
              let backgroundView = UIView()
            switch indexPath.row {
            case 0:
                   backgroundView.backgroundColor = UIColor(red: 163/255, green: 220/255, blue: 57/255, alpha: 1) // #A3DC39 (green_light_1)
               case 1:
                   backgroundView.backgroundColor = UIColor(red: 145/255, green: 197/255, blue: 50/255, alpha: 1) // #91C532 (green_light_2)
               case 2:
                   backgroundView.backgroundColor = UIColor(red: 127/255, green: 171/255, blue: 43/255, alpha: 1) // #7FAB2B (green_light_3)
            
            default:
                backgroundView.backgroundColor = UIColor.white // Default background color for other rows
            }
              backgroundView.layer.cornerRadius = 10
              backgroundView.layer.borderWidth = 4
              let myColour2 = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
            backgroundView.layer.borderColor = myColour2.cgColor
              
              // Adjust backgroundView height to be 10 points less than the row height
              let backgroundHeight = cell.frame.height - 20
              backgroundView.frame = CGRect(x: 0, y: 50, width: cell.frame.width, height: backgroundHeight)
                cell.backgroundView = backgroundView
         
        }
        cell.contentView.backgroundColor = UIColor.clear


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if indexPath.row == 10 {
           return 10 // Height for the empty row
       } else {
           return 67 // Height for regular rows
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopTen_TableViewCell
        
        // Check if myorg.originalid is in the top 10
        let isMyOrgInTopTen = sortedTopTens.contains { $0.originalid == myorg.orgid }
        
        // Handle the special cases for rows 11 (empty row) and 12 (originalid=150)
        if indexPath.row == 10 {
            cell.name.text = "" // Empty row
            cell.followers.text = ""
            cell.earnings.text = ""
            cell.logo.image = nil
            cell.ranking.text = "" // No ranking for the empty row
            return cell
        }
        
        cell.logo.layer.cornerRadius = 10
        cell.logo.layer.borderWidth = 2
        cell.logo.backgroundColor = UIColor.white
        cell.logo.layer.borderColor = UIColor.white.cgColor
        
        if indexPath.row == 11 && !isMyOrgInTopTen {
            // Find the row where originalid == 150 and display it
            if let specificItem = TopTens?.first(where: { $0.originalid == myorg.orgid }) {
                configureCell(cell: cell, with: specificItem)
                
                // Find the ranking of this item in the original TopTens array
                if let specificRankingIndex = TopTens?.firstIndex(where: { $0.originalid == myorg.orgid }) {
                    cell.ranking.text = "\(specificRankingIndex + 1)" // Show actual ranking from the original array
                } else {
                    cell.ranking.text = "N/A" // Fallback if not found
                }
                return cell
            }
        }
        
        // Regular sorting for other rows
        let topTenItem = sortedTopTens[indexPath.row]
        configureCell(cell: cell, with: topTenItem)
        
        // Assign ranking (indexPath.row + 1 for 1-based ranking)
        cell.ranking.text = "\(indexPath.row + 1)"
        
        // Set different background colors for the first three rows (your existing logic)
       
        cell.followers.font = UIFont.boldSystemFont(ofSize: cell.followers.font.pointSize)
        cell.earnings.font = UIFont.boldSystemFont(ofSize: cell.earnings.font.pointSize)
        
        // Disable selection highlight (visual change) for the cell
           cell.selectionStyle = .none

        return cell
    }

    
    func configureCell(cell: TopTen_TableViewCell, with topTenItem: Soundrops.TopTen) {
        cell.name.text = topTenItem.name ?? "No Name"
        cell.followers.text = "Følgere: \(topTenItem.followers ?? 0)"
        cell.earnings.textAlignment = .right // Right align earnings
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        let result = formatter.string(from: NSNumber(value: topTenItem.earnings ?? 0))
        cell.earnings.text = "NOK " + (result ?? "0") + ",-"
        
        if let logoUrl = topTenItem.logo {
            AF.request(logoUrl).responseImage { response in
                switch response.result {
                case .success(let image):
                    cell.logo.image = image
                case .failure(let error):
                    cell.logo.image = UIImage(named: "placeholder")
                    print("Error loading image: \(error)")
                }
            }
        } else {
            cell.logo.image = UIImage(named: "placeholder") // Placeholder if no logo
        }
    }
}
