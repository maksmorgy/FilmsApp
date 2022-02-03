import Foundation
import UIKit
import CoreData

class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let favouriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellReuseIdentifier = "favouriteCell"
    var presenter: FavouritePresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        createTableView()
        presenter.loadFilms()
    }
    
    init(presenter: FavouritePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.presenter.loadFilms()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (action, view, completionHandler:(Bool) -> Void) in
            completionHandler(true)
            let film = self.presenter.filmAtindex(index: indexPath.row)
            self.presenter.deleteFilm(data: film!, index: indexPath.row)
            self.favouriteTableView.deleteRows(at: [indexPath], with: .left)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func createTableView() {
        view.addSubview(favouriteTableView)
        NSLayoutConstraint.activate([
            favouriteTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            favouriteTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            favouriteTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            favouriteTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        favouriteTableView.register(FavouriteCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numbersOfFilms()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if  let customCell = cell as? FavouriteCell {
            customCell.updateAppearanceFor(content: presenter.filmAtindex(index: indexPath.row))
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavouriteController: FavouritePresenterDelegate {
    func updataData(data: [MOFilm]) {
        self.favouriteTableView.reloadData()
    }
}



