import Foundation
import UIKit

class ListViewController: UIViewController {
    
    var myTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var data: FilmsCollection
    let cell = "cell"
    
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
    
    private func createTableView() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(myTableView)
        createListCell()
    }
    
    func createListCell() {
        myTableView.register(MovieListCell.self, forCellReuseIdentifier: cell)
        myTableView.delegate = self
        myTableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        
        if let customCell = cell as? MovieListCell {
        let text = data.films[indexPath.row].title
            
            if let url: URL? = data.films[indexPath.row].imageURL {
            DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        customCell.movieListImage.image = image
                        customCell.movieListLabel.text = text
                    }
                }
            }
        }
        }
            return customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true )
        //let cell =  tableView.cellForRow(at: indexPath)
        let filmId = data.films[indexPath.row].filmId
        let newViewController = DetailController(id: filmId)
        self.navigationController?.pushViewController(newViewController, animated: true)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
