import Foundation
import UIKit

class MovieCell: UICollectionViewCell {
    
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        backgroundColor = .black
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Fix alignment
     func configureViews() {
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
    
    // TODO: Pass "Film" model
    func setURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.myImageView.image = image
                        }
                    }
                }
    }
}
