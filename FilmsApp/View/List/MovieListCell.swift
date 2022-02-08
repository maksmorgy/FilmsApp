import Foundation
import UIKit

class FilmListCell: UITableViewCell {
    
    // MARK: - Properties
    private let filmListLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let filmListImage: UIImageView = {
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
    func updateAppearanceFor (film: Film?) {
        DispatchQueue.main.async {
            if let url: URL = film?.imageURL, let title = film?.title {
                if let data = try? Data(contentsOf: url) {
                    self.filmListImage.image = UIImage(data: data)
                    self.filmListLabel.text = title
                    self.setupLayoutFilm()
                }
            }
            }
        }
    }

// MARK: - Setup Layout
private extension FilmListCell {
    func setupLayoutFilm() {
        addSubview(filmListImage)
        addSubview(filmListLabel)
        
        filmListImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        filmListLabel.anchor(top: topAnchor, left: filmListImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 250, height: 0, enableInsets: false)
    }
    
    func setupLayoutLoadungIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
