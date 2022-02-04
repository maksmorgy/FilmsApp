import Foundation
import UIKit

class ListViewController: UIViewController {
    
    var listTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    let cellReuseIndentifier = "cell"
    var presenter: ListPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Films"
        createTableView()
    }
    
    init(data: FilmsCollection, presenter: ListPresenterProtocol ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
        self.presenter.loadData(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Favourite") { (_, _, completionHandler) in
            DispatchQueue.global().async {
                self.presenter.saveFilms(title: self.presenter.titleAtindex(index: indexPath.row), image: self.presenter.imageAtindex(index: indexPath.row))
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
        }
        deleteAction.image = UIImage(systemName: "star")
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    private func createTableView() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        createListCell()
    }
    
    func createListCell() {
        listTableView.register(MovieListCell.self, forCellReuseIdentifier: cellReuseIndentifier)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOffilms()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIndentifier, for: indexPath)
        
        if let customCell = cell as? MovieListCell {
            DispatchQueue.main.async {
                customCell.updateAppearanceFor(title: self.presenter.titleAtindex(index: indexPath.row), image: self.presenter.imageAtindex(index: indexPath.row))
            }
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieListCell else { return }
        cell.updateAppearanceFor(title: self.presenter.titleAtindex(index: indexPath.row), image: self.presenter.imageAtindex(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true )
        let filmId = self.presenter.idAtindex(index: indexPath.row)//data.films[indexPath.row].filmId
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultMoviesEnpdoints()
        let newViewController = DetailController(id: filmId ?? "", presenter: DetailPresenter(dataTransferService: dataTransferService, endpoints: endpoints, id: filmId ?? ""))
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ListViewController: ListPresenterDelegate {
    func updateData() {
        self.listTableView.reloadData()
    }
}
