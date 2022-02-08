import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let filmsCollectionsTableView: UITableView = {
        let filmCollection = UITableView()
        filmCollection.translatesAutoresizingMaskIntoConstraints = false
        filmCollection.backgroundColor = .white
        filmCollection.isUserInteractionEnabled = true
        return filmCollection
    }()
    
    private let presenter: MainViewPresenterProtocol
    let cellReuseIdentifier = "mainCell"
    
    // MARK: - Initialization
    init(presenter: MainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Films"
        setupViews()
    }
    
}
//MARK: - Setup Layout
private extension MainViewController {
    func setupViews() {
        createTableView()
        createFilmsCollectionView()
    }
    
    func createTableView() {
        view.addSubview(filmsCollectionsTableView)
        NSLayoutConstraint.activate([
            filmsCollectionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            filmsCollectionsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            filmsCollectionsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            filmsCollectionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
    func createFilmsCollectionView() {
        filmsCollectionsTableView.register(FilmsCollectionCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        filmsCollectionsTableView.delegate = self
        filmsCollectionsTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.filmsCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if let customCell = cell as? FilmsCollectionCell {
            DispatchQueue.main.async {
                let films = self.presenter.filmsCollection?[indexPath.section].films.compactMap{ $0 }
                customCell.setFilms(films)
            }
            return customCell
        }
        return cell
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag, let film = presenter.filmsCollection?[section] else { return }
        let newViewController = ListViewController(presenter: ListPresenter(managerCD: CoreDataManager(), data: film))
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let genre = presenter.filmsCollection?[section].title
        let view = HeaderMainView(frame: CGRect(x: 0, y: 0, width: 300, height: 44), labelText: genre ?? "")
        
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

// MARK: - MainPresenterDelegate
extension MainViewController: MainPresenterDelegate {
    
    func fetchedFilms() {
        DispatchQueue.main.async {
            self.filmsCollectionsTableView.reloadData()
        }
    }
    
    func failedToFetchFilms(error: Error) {
        print(error.localizedDescription)
    }
}

