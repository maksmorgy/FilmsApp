import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    //MARK:- Properties
    private var searchTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var presenter: SearchPresenterProtocol?
    var timer = Timer()
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:- Initialization
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Films"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Film"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setupLayout()
      
        let menuBarItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
            primaryAction: nil,
            menu: makeMenu()
        )
        navigationItem.rightBarButtonItem = menuBarItem
    }
    
    //MARK:- Action
    func makeContextAction() -> UIAction {
        let image = UIImage(systemName: "line.horizontal.3.decrease.circle")
        
        return UIAction(
            title: "action",
            image: image,
            identifier: nil,
            attributes: .destructive) { _ in }
    }
    
    func makeMenu() -> UIMenu {
        let titles = ["action", "comedy", "hystory", "family", "sport"]
        
        let actions = titles
            .enumerated()
            .map { index, title in
                return UIAction(
                    title: title,
                    identifier: nil,
                    handler: {_ in })
            }
        return UIMenu(
            title: "Ganre",
            image: UIImage(systemName: "star.circle"),
            children: actions)
    }
}
private extension SearchViewController {
    func setupLayout() {
        searchTableView = UITableView(frame: view.bounds, style: .plain)
        self.view.addSubview(searchTableView)
//        NSLayoutConstraint.activate([
//            searchTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            searchTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            searchTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            searchTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//        ])
       
        self.searchTableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.searchFilms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let customCell = cell as? SearchCell {
            DispatchQueue.main.async {
                customCell.searchLabel.text = self.presenter?.searchFilms?[indexPath.row].title
                customCell.searchImage.image = self.presenter?.searchFilms?[indexPath.row].image
            }
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK:- UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchViewController.reload), object: nil)
        self.perform(#selector(SearchViewController.reload), with: nil, afterDelay: 1)
        
    }
    @objc func reload() {
        guard let text = searchController.searchBar.text else { return }
        presenter?.searchFilms(title: text)
    }
}

//MARK:- SearchPresenterDelegate
extension SearchViewController: SearchPresenterDelegate { 
    func updataData() {
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
}
