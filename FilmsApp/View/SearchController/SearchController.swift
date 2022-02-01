import Foundation
import UIKit

class SearchViewController: UIViewController {
   
    var searchTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var presenter: SearchPresenterProtocol?
    
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
        definesPresentationContext = false
        self.searchController.searchBar.delegate = self
        
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 2)
    }

    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        print(query)
    }
}
