import Foundation

protocol DetailPresenterDelegate: AnyObject {
    func updateData(data: FilmDetails?)
}

protocol DetailPresenterProtocol: AnyObject {
    var filmDescription: FilmDetails? { get set }
    var delegate: DetailPresenterDelegate? { get set }
    func fetchMovieDetails(id: String)
}

public class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - Properties
    internal var filmDescription: FilmDetails?
    private var filmId: String
    
    weak var delegate: DetailPresenterDelegate?
    private let dataTransferService: DataTransferService
    private let endpoints: MoviesEnpdoints
    
    // MARK: - Initialization
    public init(dataTransferService: DataTransferService, endpoints: MoviesEnpdoints, id: String) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
        self.filmId = id
        self.fetchMovieDetails(id: id)
    }
    
    // MARK: - Action
    func fetchMovieDetails(id: String) {
        dataTransferService.request(with: endpoints.movie(with: id)) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                let movie = FilmDetails(id: movieResponse.id ?? "", originalTitle: movieResponse.title ?? "", genres: movieResponse.genres ?? "", countries: movieResponse.countries ?? "", rating: movieResponse.imDbRating ?? "", image: movieResponse.image ?? "")
                self?.filmDescription = movie
                self?.delegate?.updateData(data: self?.filmDescription)
                
            case .failure(let error):
                print("Description error: \(error)")
            }
        }
    }
}
