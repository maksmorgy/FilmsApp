import Foundation
import UIKit

class TableViewCell: UITableViewCell {

    var label = UILabel()
    var image = UIImageView()
    weak var delegate: FilmManagerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let film = delegate?.setCell()
        //print("cell")
        self.image = UIImageView(frame: CGRect(x: 10, y: 50, width: 100, height: 100))
        let position = self.image.frame.size.width + self.image.frame.origin.x + 70

        self.label = UILabel(frame: CGRect(x: position, y: 20, width: 100, height: 30))
        //self.label.font = UIFont(name: label.font.fontName, size: 30)

        label.text = film?.original_title
        self.image.image = UIImage(systemName: "scribble")
        self.addSubview(self.label)
        self.addSubview(self.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


