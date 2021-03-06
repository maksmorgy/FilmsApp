import Foundation
import UIKit

class FilmCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    func setFilm(film: Film?) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: (film?.imageURL) as! URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.myImageView.image = image
                    }
                }
            }
        }
    }
}

//MARK: - Setup Layout
extension FilmCell {
    func setupLayout() {
        contentView.addSubview(myImageView)
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
}
