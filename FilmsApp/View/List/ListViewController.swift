import Foundation
import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Properties
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let cellReuseIndentifier = "cell"
    var presenter: ListPresenterProtocol
    
    // MARK: - Initialization
    init(presenter: ListPresenterProtocol ) {
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
        self.navigationItem.title = "Films"
        setupLayout()
    }
    
    //MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Favourite") { (_, _, completionHandler) in
            DispatchQueue.global().async {
                self.presenter.saveFilms(
                    title: self.presenter.filmAtIndex(index: indexPath.row)?.title,
                    url: self.presenter.filmAtIndex(index:indexPath.row)?.imageURL
                )
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
        }
        deleteAction.image = UIImage(systemName: "star")
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
}

//MARK: - Setup Layout
private extension ListViewController {
    func setupLayout() {
        view.addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        listTableView.register(FilmListCell.self, forCellReuseIdentifier: cellReuseIndentifier)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOffilms()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIndentifier, for: indexPath)
        
        if let customCell = cell as? FilmListCell {
            DispatchQueue.main.async {
                customCell.updateAppearanceFor(film: self.presenter.filmAtIndex(index: indexPath.row))
            }
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FilmListCell else { return }
        cell.updateAppearanceFor(film: self.presenter.filmAtIndex(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true )
        let filmId = self.presenter.filmAtIndex(index: indexPath.row)?.filmId
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultFilmsEnpdoints()
        let newViewController = DetailController(presenter: DetailPresenter(dataTransferService: dataTransferService, endpoints: endpoints, id: filmId ?? ""))
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - ListPresenterDelegate
extension ListViewController: ListPresenterDelegate {
    func updateData() {
        self.listTableView.reloadData()
    }
}
