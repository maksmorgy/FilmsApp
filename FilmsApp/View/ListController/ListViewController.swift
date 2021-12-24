import Foundation
import UIKit

class ListViewController: UIViewController {
    var myTableView = UITableView()
    var data: FilmsCollection
    let cell = "cell"
    
    override func viewDidLoad() {
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
        self.view.addSubview(myTableView)
        createListCell()
    }
    func createListCell() {
        self.myTableView.register(TableViewListCell.self, forCellReuseIdentifier: cell)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        
        if let customCell = cell as? TableViewListCell {
        let text = data.films[indexPath.row].title
            
            if let url: URL? = data.films[indexPath.row].imageURL {
            DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        customCell.myImage.image = image
                        customCell.myLabel.text = text
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
       let cell =  tableView.cellForRow(at: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
