import Foundation

protocol MainViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    //init(view: MainViewProtocol, network: NetworkManagerProtocol )
    
    func getData()
    var data: FilmsModel? { get set }
    var view: MainViewProtocol? { get set }
    func updateCollection()
}

protocol CollectionProtocol: AnyObject {
    func updateData(data: FilmsModel?)
}

class Presenter: MainViewPresenterProtocol {
    
    
    var data: FilmsModel?
    
    weak var view: MainViewProtocol?
    let network: NetworkManagerProtocol!
    var collection: CollectionProtocol?
    
    
    
    required init(network: NetworkManagerProtocol) {
        
        self.network = network
        self.getData()
        
    }
    
    func updateCollection() {
        print("collection data - \(data)")
        collection?.updateData(data: self.data)
    }
    
    func getData() {
        network.performeRequest { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    print("data - \(data)")
                    self.data = data
                    self.view?.succes()
                case.failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}



