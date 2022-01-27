import Foundation
import UIKit

class MovieListCell: UITableViewCell {
    
    var movieListLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    var movieListImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func createMovie() {
        addSubview(movieListImage)
        addSubview(movieListLabel)
        
        movieListImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        movieListLabel.anchor(top: topAnchor, left: movieListImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 250, height: 0, enableInsets: false)
    }
    
    func createLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: self.contentView.bounds.width / 2, y: self.contentView.bounds.height / 2)

    }
    
    func updateAppearanceFor (content: Film?, image: UIImage?) {
        DispatchQueue.main.async {
            self.displayContent(content, image)
        }
    }
    
    func displayContent(_ content: Film?, _ image: UIImage?) {
        
        if  let image: UIImage = image {
        if let film = content {
            movieListLabel.text = film.title
            movieListImage.image = image
            createMovie()
            loadingIndicator.stopAnimating()
        }
        } else {
            createLoadingIndicator()
            loadingIndicator.startAnimating()
            movieListImage.image = .none
            movieListLabel.text = ""
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
