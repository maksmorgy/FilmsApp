import Foundation

protocol MainViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var moviesSections: [FilmsCollection]? { get set }
    var view: MainViewProtocol? { get set }
    
    func getData()
}

public class Presenter: MainViewPresenterProtocol {
    var moviesSections: [FilmsCollection]? = []
    
    weak var view: MainViewProtocol?
   // let network: NetworkManagerProtocol!
    private let dataTransferService: DataTransferService
    private let endpoints: MoviesEnpdoints
    
    public init(dataTransferService: DataTransferService, endpoints: MoviesEnpdoints) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.getData()
    }
    
    func getData() {
        dataTransferService.request(with: endpoints.movies(with: "comedy")) {  [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let collections = FilmsCollection(films: moviesResponse.results.map({ item in
                    return Film(title: item.title, image: item.image)
                }))
                self?.moviesSections?.append(collections)
                break
            case .failure:
                print("failure")
                break
            }
        }
        
        dataTransferService.request(with: endpoints.topMovies()) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let collections = FilmsCollection(films: moviesResponse.items.map({ item in
                    return Film(title: item.title, image: item.image)
                }))
                self?.moviesSections?.append(collections)
                //self.moviesSections = moviesResponse.items
                self?.view?.succes()
                break
            case .failure:
                break
            }
        }
    }
}



