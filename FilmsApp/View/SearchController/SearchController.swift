import Foundation
import UIKit

class SearchViewController: UIViewController {
   
    var searchTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var presenter: SearchPresenterProtocol?
    var timer = Timer()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Films"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Film"
        navigationItem.searchController = searchController
        definesPresentationContext = false//
        //self.extendedLayoutIncludesOpaqueBars = true
        //self.searchController.hidesNavigationBarDuringPresentation = false
        //self.searchController.isActive = true
        //searchController.hidesNavigationBarDuringPresentation = false
        //tableView.tableHeaderView = searchController.searchBar
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//              self.searchController.searchBar.becomeFirstResponder()
//          }

        
        createTableView()
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTableView() {
        searchTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(searchTableView)
        createListCell()
    }
    
    func createListCell() {
        self.searchTableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
    }
    
}

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
extension SearchViewController: SearchPresenterDelegate { 
    func updataData() {
        DispatchQueue.main.async {
        self.searchTableView.reloadData()
        }
    }
}
