
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
}

class Presenter: MainViewPresenterProtocol {
  
    var data: FilmsModel? = FilmsModel(id: 10, original_title: "title")
    
    weak var view: MainViewProtocol?
    let network: NetworkManagerProtocol!
    
    
    
    required init(network: NetworkManagerProtocol) {
        
        self.network = network
        self.getData()
    }
    
    func getData() {
        network.performeRequest { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    self.data = data
                    self.view?.succes()
                case.failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}

