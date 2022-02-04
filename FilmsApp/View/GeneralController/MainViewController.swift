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
    
    var presenter: MainViewPresenterProtocol?
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        navigationItem.title = "Films"
        
//        let icon = UIImage(named: "magnifyingglass")
//        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50))
//        let iconButton = UIButton(frame: iconSize)
//        iconButton.setBackgroundImage(icon, for: .normal)
//        let barButton = UIBarButtonItem(customView: iconButton)
//        iconButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)

        
        //let icon = UIImage(named: "magnifyingglass")
//        let menuButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(searchTapped))
//        menuButton.image = UIImage.init(systemName: "magnifyingglass")
//        menuButton.imageInsets = UIEdgeInsets(top: 200, left: 20, bottom: 0, right: 0)
//        self.navigationItem.rightBarButtonItem = menuButton
        
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done,       target: self, action: #selector(searchTapped))
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        button.tintColor = .black
        let menuBarItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = menuBarItem
        //navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    var newViewController = SearchViewController(presenter: SearchPresenter(dataTransferService: DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com"))), endpoints: DefaultMoviesEnpdoints()))
    
    @objc func searchTapped() {
        navigationController?.pushViewController(newViewController, animated: true)
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
        let newViewController = ListViewController(data: film)
        navigationController?.pushViewController(newViewController, animated: true)
        newViewController.myTableView.reloadData()
        //let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
       // let endpoints = DefaultMoviesEnpdoints()
       // let newViewController = SearchViewController(presenter: SearchPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
        //navigationController?.pushViewController(newViewController, animated: true)
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
