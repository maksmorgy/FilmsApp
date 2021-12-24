import Foundation

public protocol MainPresenterDelegate: AnyObject {
    func fetchedMovies()
    func failedToFetchMovies(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var moviesCollection: [FilmsCollection]? { get set }
    var moviesCollection2: [FilmsCollection]? { get set }
    var delegate: MainPresenterDelegate? { get set }
    
    func getData()
}

public class MainPresenter: MainViewPresenterProtocol {
    public var moviesCollection: [FilmsCollection]? = []
    public var moviesCollection2: [FilmsCollection]? = []
    
    public weak var delegate: MainPresenterDelegate?
    private let dataTransferService: DataTransferService
    private let endpoints: MoviesEnpdoints
    
    public init(dataTransferService: DataTransferService, endpoints: MoviesEnpdoints) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.getData()
    }
    
    func getData() {
        dataTransferService.request(with: endpoints.movies(with: "action")) {  [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.results.map { item in
                    return Film(title: item.title, imageURL: URL(string: item.image)!)
                }
                self?.moviesCollection?.append(FilmsCollection(films: movies))
                self?.delegate?.fetchedMovies()
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)
            }
        }
        
        dataTransferService.request(with: endpoints.movies(with: "comedy")) {  [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.results.map { item in
                    return Film(title: item.title, imageURL: URL(string: item.image)!)
                }
                self?.moviesCollection?.append(FilmsCollection(films: movies))
                self?.delegate?.fetchedMovies()
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)

            }
        }
        
        dataTransferService.request(with: endpoints.topMovies()) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.items.map { item in
                    return Film(title: item.title, imageURL: URL(string: item.image)!)
                }
                self?.moviesCollection?.append(FilmsCollection(films: movies))
                self?.delegate?.fetchedMovies()
                //Remove debug code
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)

            }
        }
    }
}



