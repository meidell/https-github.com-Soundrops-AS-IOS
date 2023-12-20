
import Foundation
import UIKit

class Register_1_Cell: UITableViewCell {
    
    var name: String?
    var mainImage: UIImage?

    var nameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(nameView)
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        mainImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive=true
        nameView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive=true
        nameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        nameView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive=true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let name = name {
            nameView.text = name
        }
        
        if let image = mainImage {
            mainImageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
