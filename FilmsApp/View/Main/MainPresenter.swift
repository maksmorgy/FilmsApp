import Foundation

public protocol MainPresenterDelegate: AnyObject {
    func fetchedMovies()
    func failedToFetchMovies(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var filmsCollection: [FilmsCollection]? { get set }
    var delegate: MainPresenterDelegate? { get set }
    var filmDescription: FilmDetails? { get set }
    
    func getData()
}

public class MainPresenter: MainViewPresenterProtocol {
    
    // MARK: - Properties
    var filmsCollection: [FilmsCollection]? = []
    var filmDescription: FilmDetails?
    
    public weak var delegate: MainPresenterDelegate?
    private let dataTransferService: DataTransferService
    private let endpoints: MoviesEnpdoints
    
    // MARK: - Initialization
    public init(dataTransferService: DataTransferService, endpoints: MoviesEnpdoints) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.getData()
    }
    
    // MARK: - Action
    func getData() {
        let actionTitle = "action"
        let comedyTitle = "comedy"
        let topTitle = "Top Films"
        dataTransferService.request(with: endpoints.movies(with: actionTitle)) {  [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.results.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: movies, title: actionTitle))
                self?.delegate?.fetchedMovies()
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)
            }
        }
        
        dataTransferService.request(with: endpoints.movies(with: comedyTitle)) {  [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.results.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: movies, title: comedyTitle))
                self?.delegate?.fetchedMovies()
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)
            }
        }
        
        dataTransferService.request(with: endpoints.topMovies()) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.items.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: movies, title: topTitle))
                self?.delegate?.fetchedMovies()
            case .failure(let error):
                self?.delegate?.failedToFetchMovies(error: error)
            }
        }
    }
    
}


