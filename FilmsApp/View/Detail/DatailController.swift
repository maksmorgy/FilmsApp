import Foundation
import UIKit

class DetailController: UIViewController {
    
    var detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 30
        return view
    }()
    
    var filmImage = UIImageView()
    var titleLabel = UILabel()
    var ratingLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        self.view.addSubview(detailView)
    }
    
    private func createDetailView() {
        detailView = UIView(frame: view.bounds)
        
        
}
}
