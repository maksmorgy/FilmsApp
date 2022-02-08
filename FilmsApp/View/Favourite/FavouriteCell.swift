import Foundation
import UIKit

class FavouriteCell: UITableViewCell {
    
    // MARK: - Properties
    private let favouriteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let favouriteImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    func updateAppearanceFor (content: MOFilm?) {
        DispatchQueue.main.async {
            if let image = UIImage(data: (content?.filmImage)!){
                self.favouriteLabel.text = content?.filmTitle
                self.favouriteImage.image = image
                self.setupLayoutFilm()
                self.loadingIndicator.stopAnimating()
            } else {
                self.setupLayoutIndicator()
                self.loadingIndicator.startAnimating()
                self.favouriteLabel.text = ""
                self.favouriteImage.image = .none
            }
        }
    }
}

// MARK: - Setup Layout
extension FavouriteCell {
    func setupLayoutFilm() {
        addSubview(favouriteImage)
        addSubview(favouriteLabel)
        
        favouriteImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        favouriteLabel.anchor(top: topAnchor, left: favouriteImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 250, height: 0, enableInsets: false)
    }
    
    func setupLayoutIndicator() {
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}

