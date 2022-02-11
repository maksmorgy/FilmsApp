import Foundation
import UIKit

class FilmsCollectionCell: UITableViewCell {
    
    // MARK: - Properties
    private var films: [Film]? = []
    private let cell = "CollectionCell"
    
    lazy private var filmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.register(FilmCell.self, forCellWithReuseIdentifier: cell)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setFilms(_ films: [Film]?) {
        self.films = films
        filmsCollectionView.reloadData()
    }
}

// MARK: - Setup Layout
extension FilmsCollectionCell {
    func setupLayout() {
        contentView.addSubview(filmsCollectionView)
        NSLayoutConstraint.activate([
            filmsCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            filmsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            filmsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            filmsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension FilmsCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath)
        if let customCell = cell as? FilmCell {
            let film = films?[indexPath.row]
            customCell.setFilm(film: film)
            return customCell
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FilmsCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
}
