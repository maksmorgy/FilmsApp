import Foundation
import UIKit

class DetailController: UIViewController {
    
    // MARK: - Properties
    private var presenter: DetailPresenterProtocol
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let ratingTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let genreTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let countryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Initialization
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        addObjects()
        setupLayout()
    }
}

// MARK: - Setup Layout
private extension DetailController {
    func addObjects() {
        view.addSubview(imageView)
        view.addSubview(titleTextView)
        
        view.addSubview(ratingTextView)
        view.addSubview(genreTextView)
        view.addSubview(countryTextView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleTextView.widthAnchor.constraint(equalToConstant: 400),
            titleTextView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 30),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            ratingTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            ratingTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            ratingTextView.widthAnchor.constraint(equalToConstant: 200),
            ratingTextView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            genreTextView.topAnchor.constraint(equalTo: ratingTextView.bottomAnchor, constant: 20),
            genreTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            genreTextView.widthAnchor.constraint(equalToConstant: 200),
            genreTextView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            countryTextView.topAnchor.constraint(equalTo: genreTextView.bottomAnchor, constant: 20),
            countryTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            countryTextView.widthAnchor.constraint(equalToConstant: 200),
            countryTextView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func updateFontSize() {
        titleTextView.font = .systemFont(ofSize: 30)
        countryTextView.font = .systemFont(ofSize: 20)
        genreTextView.font = .systemFont(ofSize: 20)
        ratingTextView.font = .systemFont(ofSize: 20)
    }
}

//MARK: - DetailPresenterDelegate
extension DetailController: DetailPresenterDelegate {
    func updateData(data: FilmDetails?) {
        DispatchQueue.main.async {
            self.updateFontSize()
            
            self.titleTextView.text = "Title: \(data!.originalTitle)"
            self.countryTextView.text = "Country: \(data!.countries)"
            self.genreTextView.text = "Genre: \(data!.genres)"
            self.ratingTextView.text = "Rating: \(data!.rating)"
            
            let url = URL(string: data!.image)
            if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
                self.imageView.image = image
            }
        }
    }
}
