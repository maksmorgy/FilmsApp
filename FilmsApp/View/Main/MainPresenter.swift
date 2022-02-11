import Foundation

public protocol MainPresenterDelegate: AnyObject {
    func fetchedFilms()
    func failedToFetchFilms(error: Error)
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
    private let endpoints: FilmsEnpdoints
    
    // MARK: - Initialization
    public init(dataTransferService: DataTransferService, endpoints: FilmsEnpdoints) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.getData()
    }
    
    // MARK: - Action
    func getData() {
        let actionTitle = "action"
        let comedyTitle = "comedy"
        let topTitle = "Top Films"
        dataTransferService.request(with: endpoints.films(with: actionTitle)) {  [weak self] result in
            switch result {
            case .success(let filmsResponse):
                let films = filmsResponse.results.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: films, title: actionTitle))
                self?.delegate?.fetchedFilms()
            case .failure(let error):
                self?.delegate?.failedToFetchFilms(error: error)
            }
        }
        
        dataTransferService.request(with: endpoints.films(with: comedyTitle)) {  [weak self] result in
            switch result {
            case .success(let filmsResponse):
                let films = filmsResponse.results.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: films, title: comedyTitle))
                self?.delegate?.fetchedFilms()
            case .failure(let error):
                self?.delegate?.failedToFetchFilms(error: error)
            }
        }
        
        dataTransferService.request(with: endpoints.topFilms()) { [weak self] result in
            switch result {
            case .success(let filmsResponse):
                let films = filmsResponse.items.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.filmsCollection?.append(FilmsCollection(films: films, title: topTitle))
                self?.delegate?.fetchedFilms()
            case .failure(let error):
                self?.delegate?.failedToFetchFilms(error: error)
            }
        }
    }
    
}



