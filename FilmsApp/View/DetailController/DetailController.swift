import Foundation
import UIKit

class DetailController: UIViewController {
    
    let filmId: String
    public var descriptionFilm: DetailFilm?
    var controller: MainViewController?
 
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "scribble")
        return image
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = textView.font?.withSize(40)
        return textView
    }()
    
    let ratingTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Rating:"
        textView.font = textView.font?.withSize(20)
        return textView
    }()
    
    let genreTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Genre:"
        textView.font = textView.font?.withSize(20)
        return textView
    }()
    
    let countryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Country:"
        textView.font = textView.font?.withSize(20)
        return textView
    }()
    
    init(id: String ) {
        self.filmId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print(filmId)
        print(controller)
        descriptionFilm = controller?.getId(id: filmId)
        
        view.backgroundColor = .white
        titleTextView.text = "Title: \(descriptionFilm?.title) "
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
    titleTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    titleTextView.heightAnchor.constraint(equalToConstant: 65).isActive = true
    
    imageView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 30).isActive = true
    imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
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
}

