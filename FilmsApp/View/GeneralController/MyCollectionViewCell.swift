import Foundation
import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
        var myImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        backgroundColor = .black
        configureViews()
                
        
    }
     func configureViews() {
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
