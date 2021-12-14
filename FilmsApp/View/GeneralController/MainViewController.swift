//
//  ViewController.swift
//  FilmsApp
//
//  Created by Максим Моргун on 06.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    var myTableView = UITableView()
    var film: FilmsModel?
    var presenter: MainViewPresenterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        self.navigationItem.title = "Films"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    init(presenter: MainViewPresenterProtocol) {
        
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.view = self        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTableView() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        //create constraints for myTableView
        self.view.addSubview(myTableView)
        self.myTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.backgroundColor = .white
        myTableView.isUserInteractionEnabled = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        print("///////////")
        presenter?.updateCollection()
       // collectionDelegate?.updateCollection()
//        DispatchQueue.main.async {
//            let film = self.presenter?.data?.urlImage
//            self.cell1.myImageView.image = film?[0]
//        }
        
        //tableView.reloadData()

        return cell
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }
        let newViewController = ListViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        var genre = ["Cartoons", "Films", "Serials"]
        let label = UILabel(frame: CGRect(x: 5, y: 20, width: 200, height: 40))
        label.text = genre[section]
        view.addSubview(label)

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped(_:))
        )
        view.tag = section
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


extension ViewController: MainViewProtocol {
    func succes() {
        myTableView.reloadData()
        
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
}

