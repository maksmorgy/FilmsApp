import Foundation
import UIKit

class SearchViewController: UIViewController {
   
    var searchTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    let filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
    
    var imageView: UIImageView!
    
    var presenter: SearchPresenterProtocol?
    var timer = Timer()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    let popover = PopoverContentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Films"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Film"
        definesPresentationContext = false

        createTableView()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.isUserInteractionEnabled = true
        let save = UIAction(title: "action", state: .on, handler: {_ in })
        let comedy = UIAction(title: "comedy", state: .on, handler: {_ in })
        let menu = UIMenu(title: "Menu", image: nil, identifier: nil, options: [], children: [save, comedy])
        
        let menuBarItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
            primaryAction: nil,
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = menuBarItem
        
        
    }
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filterTapped() {

        let vc = PopoverContentController()
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .any
        popover?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
          
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

extension SearchViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

class PopoverContentController: UIViewController {
    let genre = ["action", "comedy", "famaly", "hystory", "adwanture", "war", "crime"]
    
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
    }
    
    private func createTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        createListCell()
    }
    func createListCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PopoverContentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = genre[indexPath.row]
        return cell
    }
    
}

class EmptyViewController : UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.red
    }
}

