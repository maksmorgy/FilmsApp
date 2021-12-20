import Foundation
import UIKit

class ListViewController: UIViewController {
    var myTableView = UITableView()
    var data: FilmsCollection?
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
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        //self.myTableView.backgroundColor = .white
        //myTableView.isUserInteractionEnabled = true
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "films"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true )
       let cell =  tableView.cellForRow(at: indexPath)
        cell?.textLabel?.text = "text"
        print("List")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
