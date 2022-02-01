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

class MainViewController: UIViewController {
    
    var moviesCollectionsTableView: UITableView = {
        let movieCollection = UITableView()
        return movieCollection
    }()
    
    
//    let searchController = UISearchController(searchResultsController: nil)
//    var isSearchBarEmpty: Bool {
//      return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    var presenter: MainViewPresenterProtocol?
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        navigationItem.title = "Films"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Film"
//        navigationItem.searchController = searchController
        //definesPresentationContext = true
    }
    
    init(presenter: MainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTableView() {
        moviesCollectionsTableView = UITableView(frame: view.bounds, style: .plain)
        self.view.addSubview(moviesCollectionsTableView)
        createMoviesCollectionView()
    }
    
    func createMoviesCollectionView() {
        self.moviesCollectionsTableView.register(MoviesCollectionCell.self, forCellReuseIdentifier: "cell")
        self.moviesCollectionsTableView.delegate = self
        self.moviesCollectionsTableView.dataSource = self
        self.moviesCollectionsTableView.backgroundColor = .white
        self.moviesCollectionsTableView.isUserInteractionEnabled = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.filmsCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let customCell = cell as? MoviesCollectionCell {
            let images: [URL] = presenter?.filmsCollection?[indexPath.section].films.map({ film in
                let image = film.imageURL
                return image! }) ?? []
            customCell.setImages(images)
            return customCell
        }
        return cell
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag, let film = presenter?.filmsCollection?[section] else { return }
//        let newViewController = ListViewController(data: film)
//        navigationController?.pushViewController(newViewController, animated: true)
//        newViewController.myTableView.reloadData()
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultMoviesEnpdoints()
        let newViewController = SearchViewController(presenter: SearchPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
        navigationController?.pushViewController(newViewController, animated: true)
        //newViewController.myTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var genre = presenter?.filmsCollection?[section].title
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

//extension MainViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        
//    }
//}
