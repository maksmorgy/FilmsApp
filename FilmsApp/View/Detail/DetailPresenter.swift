import Foundation

protocol DetailPresenterDelegate: AnyObject {
    func updateData(data: FilmDetails?)
}

protocol DetailPresenterProtocol: AnyObject {
    var filmDetails: FilmDetails? { get set }
    var delegate: DetailPresenterDelegate? { get set }
    func fetchFilmDetails(id: String)
}

public class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - Properties
    var filmDetails: FilmDetails?
    private var filmId: String
    
    weak var delegate: DetailPresenterDelegate?
    private let dataTransferService: DataTransferService
    private let endpoints: FilmsEnpdoints
    
    // MARK: - Initialization
    public init(dataTransferService: DataTransferService, endpoints: FilmsEnpdoints, id: String) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.filmId = id
        self.fetchFilmDetails(id: id)
    }
    
    // MARK: - Action
    func fetchFilmDetails(id: String) {
        dataTransferService.request(with: endpoints.film(with: id)) { [weak self] result in
            switch result {
            case .success(let filmResponse):
                let film = FilmDetails(id: filmResponse.id ?? "", originalTitle: filmResponse.title ?? "", genres: filmResponse.genres ?? "", countries: filmResponse.countries ?? "", rating: filmResponse.imDbRating ?? "", image: filmResponse.image ?? "")
                self?.filmDetails = film
                self?.delegate?.updateData(data: self?.filmDetails)
                
            case .failure(let error):
                print("Description error: \(error)")
            }
        }
    }
}
