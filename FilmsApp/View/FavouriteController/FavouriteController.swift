import Foundation
import UIKit
import CoreData

class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favouriteTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var films = [Film_Data]()
    let context = CoreDataManager.instance.persistentContainer.viewContext
    let cell = "favouriteCell"
    
    var presenter: FavouritePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        createTableView()
        presenter?.loadFilms()
    }
    
    init(presenter: FavouritePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.presenter?.loadFilms()
            self.favouriteTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let film = self.films.remove(at: indexPath.row)
            self.presenter?.deleteFilm(data: film)
            self.favouriteTableView.deleteRows(at: [indexPath], with: .left)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func createTableView() {
        favouriteTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(favouriteTableView)
        favouriteTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        favouriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        favouriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        favouriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        favouriteTableView.register(FavouriteCell.self, forCellReuseIdentifier: cell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        
        if  let customCell = cell as? FavouriteCell {
            customCell.updateAppearanceFor(content: films[indexPath.row])
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavouriteController: FavouritePresenterDelegate {
    func updataData(data: [Film_Data]) {
        self.films = data
    }
}



