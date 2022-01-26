import Foundation
import UIKit

class DetailController: UIViewController {
    let filmId: String
    var presenter: DetailPresenterProtocol?
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let ratingTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let genreTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let countryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(id: String, presenter: DetailPresenterProtocol) {
        self.filmId = id
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        var description = presenter?.filmDescription
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(titleTextView)
        
        view.addSubview(ratingTextView)
        view.addSubview(genreTextView)
        view.addSubview(countryTextView)
        setupLayout()
    }
    
    private func setupLayout() {
        
        titleTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleTextView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 30).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        ratingTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        ratingTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        ratingTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        ratingTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genreTextView.topAnchor.constraint(equalTo: ratingTextView.bottomAnchor, constant: 20).isActive = true
        genreTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        genreTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        genreTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        countryTextView.topAnchor.constraint(equalTo: genreTextView.bottomAnchor, constant: 20).isActive = true
        countryTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        countryTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        countryTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func updateFontSize() {
        self.titleTextView.font = .systemFont(ofSize: 30)
        self.countryTextView.font = .systemFont(ofSize: 20)
        self.genreTextView.font = .systemFont(ofSize: 20)
        self.ratingTextView.font = .systemFont(ofSize: 20)
    }
    
}

extension DetailController: DetailPresenterDelegate {
    func updateData(data: DetailFilm?) {
        DispatchQueue.main.async {
            self.updateFontSize()
            
            self.titleTextView.text = "Title: \(data!.originalTitle)"
            self.countryTextView.text = "Country: \(data!.countries)"
            self.genreTextView.text = "Genre: \(data!.genres)"
            self.ratingTextView.text = "Rating: \(data!.rating)"
            
            let url = URL(string: data!.image)
            if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        
    }
    
    
    
    
}
