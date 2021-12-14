import Foundation

protocol MainViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var moviesSections: [FilmsModel] { get set }
    var view: MainViewProtocol? { get set }
    
    func getData()
}

protocol CollectionProtocol: AnyObject {
    func updateData(data: FilmsModel?)
}

class Presenter: MainViewPresenterProtocol {
    
    var moviesSections: [FilmsModel] = []
    
    weak var view: MainViewProtocol?
    let network: NetworkManagerProtocol!
//    var collection: CollectionProtocol?
    
    required init(network: NetworkManagerProtocol) {
        self.network = network
        self.getData()
    }
    
    func getData() {
        network.performeRequest { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let movies):
                    print("data - \(movies)")
                    self.moviesSections = [movies, movies]
                    self.view?.succes()
                case.failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}



