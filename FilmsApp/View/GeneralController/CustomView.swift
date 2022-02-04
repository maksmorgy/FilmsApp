import Foundation
import UIKit

class CustomView: UIView {
    var labelText: String
    init(frame: CGRect, labelText: String) {
        self.labelText = labelText
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubViews() {
        backgroundColor = .white
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
