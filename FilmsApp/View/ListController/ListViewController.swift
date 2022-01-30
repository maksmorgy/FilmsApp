import Foundation
import UIKit

class ListViewController: UIViewController {
    
    var listTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    var data: FilmsCollection
    let cell = "cell"
    let context = CoreDataManager.instance.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Films"
        createTableView()
    }
    
    init(data: FilmsCollection ) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let myDel = UIContextualAction(style: .normal, title: "Favourite") { (_, _, complitionHand) in
            let film = Film_Data(context: self.context)
            if let data = try? Data(contentsOf: (self.data.films[indexPath.row].imageURL)! ) {
                film.filmImage = data
                     
            }
            
            film.filmTitle = self.data.films[indexPath.row].title
            //film.filmImage = self.data.films[indexPath.row].imageURL
            CoreDataManager.instance.saveContext()
            complitionHand(true)
        }
        
        
        myDel.image = UIImage(systemName: "star")
        return UISwipeActionsConfiguration(actions:[myDel])
    }
    
    private func createTableView() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listTableView)
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        createListCell()
    }
    
    func createListCell() {
        listTableView.register(MovieListCell.self, forCellReuseIdentifier: cell)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        
        if let customCell = cell as? MovieListCell {
            customCell.updateAppearanceFor(content: data.films[indexPath.row], image: .none)
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieListCell else { return }
        
        if let url: URL? = data.films[indexPath.row].imageURL {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.updateAppearanceFor(content: self?.data.films[indexPath.row], image: image)
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true )
        let filmId = data.films[indexPath.row].filmId
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultMoviesEnpdoints()
        let newViewController = DetailController(id: filmId, presenter: DetailPresenter(dataTransferService: dataTransferService, endpoints: endpoints, id: filmId))
        self.navigationController?.pushViewController(newViewController, animated: true)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
