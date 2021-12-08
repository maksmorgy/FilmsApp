//
//  ViewController.swift
//  FilmsApp
//
//  Created by Максим Моргун on 06.12.2021.
//

import UIKit

class ViewController: UIViewController {
 
    var myTableView = UITableView()
    private let presenter = Presenter()
    private let network = NetworkManager()
    var cell = TableViewCell()
    var film: FilmsModel?
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        self.navigationItem.title = "Films"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        network.delegate = self
        cell.delegate = self
        
        print("viewController")
        network.fetchFilm(film: "Ali")
        myTableView.reloadData()
        
    }
    
    func createTableView() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        self.view.addSubview(myTableView)
        self.myTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //cell.setCell(method TableVieCell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ViewController: FilmManagerDelegate {
    
    
    func didUpdateData(film: FilmsModel) {
        self.film?.id = film.id
        self.film?.original_title = film.original_title
        print(film.original_title)
        print("update Data")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func setCell() -> FilmsModel? {
        print("setData")
        return film
    }
    
    
}


