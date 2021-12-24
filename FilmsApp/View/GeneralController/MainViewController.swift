import UIKit

class MainViewController: UIViewController {
    
    var moviesCollectionsTableView = UITableView()
    var presenter: MainViewPresenterProtocol?
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        navigationItem.title = "Films"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init(presenter: MainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTableView() {
        moviesCollectionsTableView = UITableView(frame: view.bounds, style: .plain)
        self.view.addSubview(moviesCollectionsTableView)
        createMoviesCollectionView()
    }
    func createMoviesCollectionView() {
        self.moviesCollectionsTableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        self.moviesCollectionsTableView.delegate = self
        self.moviesCollectionsTableView.dataSource = self
        self.moviesCollectionsTableView.backgroundColor = .white
        self.moviesCollectionsTableView.isUserInteractionEnabled = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.moviesCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let customCell = cell as? MainCell {
            let images: [URL] = presenter?.moviesCollection?[indexPath.section].films.map({ film  in
                let image = film.imageURL
                return image }) ?? []
            customCell.setImages(images)
            return customCell
        }
        return cell
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }
        guard let film = presenter?.moviesCollection?[section] else { return }
        let newViewController = ListViewController(data: film)
        self.navigationController?.pushViewController(newViewController, animated: true)
        newViewController.myTableView.reloadData()
    }
    
//    func createCustomView() {
//        customView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
//        var label = UILabel(frame: CGRect(x: 5, y: 20, width: 200, height: 40))
//        self.customView.addSubview(label)
//    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let genre = ["Top Films", "Comedy", "Action"]
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
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

extension MainViewController: MainPresenterDelegate {
    
    func fetchedMovies() {
        DispatchQueue.main.async {
            self.moviesCollectionsTableView.reloadData()
        }
    }
    
    func failedToFetchMovies(error: Error) {
        print(error.localizedDescription)
    }
}

