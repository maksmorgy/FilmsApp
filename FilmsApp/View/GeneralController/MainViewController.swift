import UIKit

// TODO: Rename folder "GeneralController" to "Main", "FavouriteController" to "Favourite" and "ListController" to "List"

// TODO: Remove commented code

//class CustomView: UIView {
//    var labelText: String
//    init(frame: CGRect, labelText: String) {
//        self.labelText = labelText
//        super.init(frame: frame)
//        createSubViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func createSubViews() {
//        backgroundColor = .white
//        let label = UILabel()
//        label.textColor = UIColor.black
//        label.text = labelText
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        addSubview(label)
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}

class MainViewController: UIViewController {
    
    // TODO: Make constant and private
    var moviesCollectionsTableView: UITableView = {
        let movieCollection = UITableView()
        movieCollection.translatesAutoresizingMaskIntoConstraints = false
        return movieCollection
    }()
    
    // TODO: Make constant and private
    var presenter: MainViewPresenterProtocol
    // TODO: Remove unneeded object
    var customView = UIView()
    let cellReuseIdentifier = "mainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        navigationItem.title = "Films"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // TODO: Put initializers right after properties list
    
    init(presenter: MainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Move views configurations to extensions
    
    private func createTableView() {
        view.addSubview(moviesCollectionsTableView)
        NSLayoutConstraint.activate([
            moviesCollectionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            moviesCollectionsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            moviesCollectionsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            moviesCollectionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        createMoviesCollectionView()
    }
    
    func createMoviesCollectionView() {
        moviesCollectionsTableView.register(MoviesCollectionCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        moviesCollectionsTableView.delegate = self
        moviesCollectionsTableView.dataSource = self
        moviesCollectionsTableView.backgroundColor = .white
        moviesCollectionsTableView.isUserInteractionEnabled = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.filmsCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if let customCell = cell as? MoviesCollectionCell {
            DispatchQueue.main.async {
                // TODO: Apply swift suggestion
                let images = self.presenter.filmsCollection?[indexPath.section].films.compactMap{ $0.imageURL as? URL}
                customCell.setImages(images!)
            }
            return customCell
        }
        return cell
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag, let film = presenter.filmsCollection?[section] else { return }
        let newViewController = ListViewController(data: film, presenter: ListPresenter())
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // TODO: Apply swift suggestion
        var genre = presenter.filmsCollection?[section].title
        // TODO: Apply swift suggestion
        var view = CustomView(frame: CGRect(x: 0, y: 0, width: 300, height: 44), labelText: genre ?? "")
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped(_:))
        )
        view.tag = section
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MainViewController: MainPresenterDelegate {
    
    func fetchedMovies() {
        DispatchQueue.main.async {
            self.moviesCollectionsTableView.reloadData()
        }
    }
    
    func failedToFetchMovies(error: Error) {
        print(error.localizedDescription)
    }
}

