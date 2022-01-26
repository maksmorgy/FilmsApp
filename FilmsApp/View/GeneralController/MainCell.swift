import Foundation
import UIKit

class MoviesCollectionCell: UITableViewCell {
    
    private var imageURLs: [URL] = []
    let cell = "CollectionCell"
    
    lazy var moviesCollectionView: UICollectionView = {
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
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cell)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCollectionViewLayout() {
        contentView.addSubview(moviesCollectionView)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            moviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            moviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            moviesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    public func setImages(_ urls: [URL]) {
        self.imageURLs = urls
        moviesCollectionView.reloadData()
    }
}

extension MoviesCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath)
        if let customCell = cell as? MovieCell {
            let url = imageURLs[indexPath.row]
            customCell.setURL(url: url)
            return customCell
        }
        return cell
    }
}

extension MoviesCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
}
