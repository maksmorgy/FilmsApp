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

//    var label = UILabel()
//    var image = UIImageView()
    weak var delegate: FilmManagerDelegate?
    
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
        myLabel.text = "Nice Layout"
        myLabel.font = myLabel.font.withSize(30)
        
        
        let film = delegate?.setCell()
        //print("cell")
//        self.image = UIImageView(frame: CGRect(x: 10, y: 50, width: 100, height: 100))
//        let position = self.image.frame.size.width + self.image.frame.origin.x + 70
//
//        self.label = UILabel(frame: CGRect(x: position, y: 20, width: 100, height: 30))
//        //self.label.font = UIFont(name: label.font.fontName, size: 30)
//
//        label.text = film?.original_title
//        self.image.image = UIImage(systemName: "scribble")
//        self.addSubview(self.label)
//        self.addSubview(self.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


