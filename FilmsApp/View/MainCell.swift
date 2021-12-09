import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    let myImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "scribble"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(myImageView)
        self.addSubview(myLabel)
        
        myImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        myImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        myLabel.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 50).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //myLabel.text = "Nice Layout"
        myLabel.font = myLabel.font.withSize(30)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


