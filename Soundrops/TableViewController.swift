import Foundation
import UIKit

struct CellData {
    let image: UIImage?
    let name: String?
}

class TableViewController: UITableViewController {
    
    var data = [CellData]()
    var myImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [CellData.init(image: myImage , name: "Viking"),CellData.init(image: myImage , name: "Viking"),CellData.init(image: myImage , name: "Viking"),CellData.init(image: myImage , name: "Viking")]

        self.tableView.register(Register_1_Cell.self, forCellReuseIdentifier: "custom")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! Register_1_Cell
        cell.mainImage = data[indexPath.row].image
        cell.name = data[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
}
