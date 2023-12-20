import UIKit

class NearMeTableViewCell: UITableViewCell {
    
    
   
    @IBOutlet weak var AddLabelView: UILabel!
    @IBOutlet weak var AddImageView: UIImageView!
    
    
}

extension UIView {
    func ApplyDesign() {
        self.backgroundColor = UIColor.darkGray
    }
}

class myView: UIView {
    override func didMoveToWindow() {
        self.backgroundColor = UIColor.darkGray
    }
}
