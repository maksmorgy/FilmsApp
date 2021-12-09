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
    var presenter: MainViewPresenterProtocol
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        self.navigationItem.title = "Films"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //myTableView.reloadData()
        
    }
    init(presenter: MainViewPresenterProtocol) {
        
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTableView() {
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
        if let film1 = presenter.data?.original_title {
            cell.myLabel.text = film1
        } else {
            print("error")
        }
        //cell.myLabel.text = film
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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

