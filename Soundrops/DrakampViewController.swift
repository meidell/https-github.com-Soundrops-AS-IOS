import UIKit
import Alamofire
import AlamofireImage

class DrakampViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    // Change sortedTopTens to sortedCompTens
    var sortedComp: [CompetitionLeaderboard] = []
    var didScroll: Bool = false
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Create and configure the label
        let competitionLabel = UILabel()
        competitionLabel.numberOfLines = 0  // Allow multiline
        competitionLabel.font = UIFont.systemFont(ofSize: 16)
        if let competition = currentCompetitionData {
            let formattedText = formatCompetitionText(competition: competition)
            competitionLabel.text = formattedText
        }
        competitionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(competitionLabel)
       NSLayoutConstraint.activate([
              competitionLabel.topAnchor.constraint(equalTo: tableview.bottomAnchor, constant: 20),
              competitionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              competitionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
          ])
        
        view.bringSubviewToFront(btnHome)
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        
        sortedComp = Array((CompTens?.sorted(by: { $0.userCount > $1.userCount }).prefix(20)) ?? [])        
        self.tableview.frame.origin.y = self.imageLogo.frame.maxY + 10
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = UIColor.clear
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.reloadData()
        
        setupButton()

        view.bringSubviewToFront(btnDel)

        didScroll = false
        
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
                tableview.refreshControl = refreshControl
    }
    
    @objc func refreshTableData() {
        
        c_api.getrequest(params: "", key: "getcompetition") {
               DispatchQueue.main.async {
                   // Reload table data on the main thread
                   self.tableview.reloadData()
                   
                   // End refreshing animation on the main thread
                   self.refreshControl.endRefreshing()
               }
           }
        
    }
    
    func formatCompetitionText(competition: CompetitionData) -> String {
            // Convert the fromdata and endDate (in YYYYMMDD format) to a readable date
            let fromDateFormatted = formatDate(from: competition.fromdata)
            let endDateFormatted = formatDate(from: competition.endDate)
            return """
            \(competition.name)
            Varighet: \(fromDateFormatted) - \(endDateFormatted)
            \(competition.rules)
            """
    }

    func formatDate(from intDate: Int) -> String {
        let dateString = String(intDate)
        let year = dateString.prefix(4)
        let month = dateString.dropFirst(4).prefix(2)
        let day = dateString.dropFirst(6).prefix(2)
        return "\(day).\(month).\(year)"
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            // swipes from top to bottom of screen -> down
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.btnHome.alpha = 1
                self.btnDel.alpha = 1
            }, completion: nil)
        } else {
            // swipes from bottom to top of screen -> up
            if didScroll == true {
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.btnHome.alpha = 0
                    self.btnDel.alpha = 0
                }, completion: nil)
            }
            didScroll = true
        }
    }

    @IBAction func btnHome(_ sender: Any) {
      //  self.performSegue(withIdentifier: "topten_dashboard", sender: self)
    }

    @IBAction func btnDel(_ sender: Any) {
        
        let orgIdString = String(decoding: String(myorg.orgid).data(using: String.Encoding.utf8)!, as: UTF8.self)
        let usernameString = String(decoding: myuser.username.data(using: .utf8)!, as: UTF8.self)
        let data = "orgid#" + orgIdString + "__user#" + usernameString
        
        let encodedData = (data.data(using: .utf8)?.base64EncodedString())!
        let urlString = "https://share50.no/competition/" + encodedData
        // Swift code
       // let urlString = "https://vg.no"
        guard let url = URL(string: urlString) else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
        present(activityViewController, animated: true, completion: nil)
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
        
        btnDel.frame.size.width = btnDel.frame.height
        btnDel.backgroundColor = .white
        btnDel.layer.cornerRadius = btnDel.frame.width / 2
        btnDel.layer.borderWidth = 1
        btnDel.layer.borderColor = myColour2.cgColor
        btnDel.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image2 = UIImage(systemName: "scale.3d", withConfiguration: largeConfig2)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnDel.setImage(image2, for: .normal)
        btnDel.imageView?.contentMode = .scaleAspectFit
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isMyOrgInTopTen = sortedComp.contains { $0.organisation.name == myorg.orgname }
        return sortedComp.count + (isMyOrgInTopTen ? 0 : 2)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 20 {
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
       if indexPath.row == 20 {
           return 10 // Height for the empty row
       } else {
           return 67 // Height for regular rows
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Drakamp_TableViewCell
        // Check if myorg.orgid is in the top 10 (adjusted for CompTens)
        let isMyOrgInTopTen = sortedComp.contains { $0.organisation.name == myorg.orgname }
        
        // Handle the special cases for rows 21 (empty row) and 22 (organisation==myorg)
        if indexPath.row == 20 {
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
        
        if indexPath.row == 21 && !isMyOrgInTopTen {
            // Find the row where organisation.name == myorg.orgname and display it
            if let specificItem = CompTens?.first(where: { $0.organisation.name == myorg.orgname }) {
                configureCell(cell: cell, with: specificItem)
                
                // Find the ranking of this item in the original CompTens array
                if let specificRankingIndex = CompTens?.firstIndex(where: { $0.organisation.name == myorg.orgname }) {
                    cell.ranking.text = "\(specificRankingIndex + 1)" // Show actual ranking from the original array
                } else {
                    cell.ranking.text = "N/A" // Fallback if not found
                }
                return cell
            }
        } else {
            print(sortedComp.count, indexPath.row)
            // Regular sorting for other rows (adjusted for CompTens)
            let compTenItem = sortedComp[indexPath.row]
            configureCell(cell: cell, with: compTenItem)
        
            // Assign ranking (indexPath.row + 1 for 1-based ranking)
            cell.ranking.text = "\(indexPath.row + 1)"
            
            // Set different background colors for the first three rows (your existing logic)
            cell.followers.font = UIFont.boldSystemFont(ofSize: cell.followers.font.pointSize)
            cell.earnings.font = UIFont.boldSystemFont(ofSize: cell.earnings.font.pointSize)
            
            // Disable selection highlight (visual change) for the cell
            cell.selectionStyle = .none
        }
  
        return cell
    }
    
    // Adjust configureCell to work with CompetitionLeaderboard instead of TopTen
    func configureCell(cell: Drakamp_TableViewCell, with compTenItem: CompetitionLeaderboard) {
        cell.name.text = compTenItem.organisation.name
        cell.followers.text = "Nye følgere: \(compTenItem.userCount)"
        cell.earnings.textAlignment = .right // Right align earnings
        cell.earnings.text = "" // No earnings in this data model
        
        // Since logo is non-optional, you can use it directly
        let logoUrl = compTenItem.organisation.logo
        AF.request(logoUrl).responseImage { response in
            switch response.result {
            case .success(let image):
                cell.logo.image = image
            case .failure(let error):
                cell.logo.image = UIImage(named: "placeholder")
                print("Error loading image: \(error)")
            }
           
        }
    }

}
