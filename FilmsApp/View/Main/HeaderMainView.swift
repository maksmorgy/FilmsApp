import Foundation
import UIKit

class HeaderMainView: UIView {
    
    // MARK: - Properties
    private let labelText: String
    
    // MARK: - Initialization
    init(frame: CGRect, labelText: String) {
        self.labelText = labelText
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure Views
private extension HeaderMainView {
    func configureViews() {
        let label: UILabel = {
            let label = UILabel()
            label.textColor = UIColor.black
            label.text = labelText
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
            return label
        }()
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        backgroundColor = .white
    }
}
