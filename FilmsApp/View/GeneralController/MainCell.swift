import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    private var films: [URL] = []
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.dataSource = self
        v.isPagingEnabled = true
        v.isScrollEnabled = true
        v.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        v.backgroundColor = .white
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImages(_ films: [URL]) {
        self.films = films
        collectionView.reloadData()
    }
}

extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MyCollectionViewCell
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: self!.films[indexPath.row] ) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.myImageView.image = image
                            }
                        }
                    }
                }
        
        cell.backgroundColor = .yellow
        return cell
    }
}

extension TableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
}
