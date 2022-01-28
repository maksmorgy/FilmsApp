import Foundation
import UIKit
import CoreData
import SwipeCellKit

class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favouriteTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var films = [FilmData]()
    let context = CoreDataManager.instance.persistentContainer.viewContext
    let cell = "favouriteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        createTableView()
        loadFilms()
    }
    
    func loadFilms() {
        let request : NSFetchRequest<FilmData> = FilmData.fetchRequest()
        
        do{
            films = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.loadFilms()
            self.favouriteTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let film = self.films.remove(at: indexPath.row)
            CoreDataManager.instance.delete(film: film)
            self.favouriteTableView.deleteRows(at: [indexPath], with: .left)
        })
        //deleteAction.image = UIImage(systemName: "delete-icon")
        
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

