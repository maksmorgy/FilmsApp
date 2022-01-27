import Foundation
import UIKit

class FavouriteCell: UITableViewCell {
    
    var favouriteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    var favouriteImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func createMovie() {
        addSubview(favouriteImage)
        addSubview(favouriteLabel)
        
        favouriteImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        favouriteLabel.anchor(top: topAnchor, left: favouriteImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 250, height: 0, enableInsets: false)
    }
    
    func updateAppearanceFor (content: FilmData?) {
        DispatchQueue.main.async {
            self.displayContent(content)
        }
    }
    
    func createLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: self.contentView.bounds.width / 2, y: self.contentView.bounds.height / 2)

    }
    
    func displayContent(_ content: FilmData?) {
        DispatchQueue.main.async {
            self.createLoadingIndicator()
            self.loadingIndicator.startAnimating()
            self.favouriteLabel.text = ""
            self.favouriteImage.image = .none
        
        if let data = try? Data(contentsOf: (content?.filmImage)! ) {
                let image = UIImage(data: data)
                self.favouriteImage.image = image
                self.favouriteLabel.text = content?.filmTitle
                self.createMovie()
                self.loadingIndicator.stopAnimating()
        }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
