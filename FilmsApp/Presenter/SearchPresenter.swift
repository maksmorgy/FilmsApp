import Foundation
import CoreData
import UIKit

protocol SearchPresenterDelegate: AnyObject {
    func updataData()
}

protocol SearchPresenterProtocol: AnyObject {
    var searchFilms: [SearchFilm]? { get set }
    var delegate: SearchPresenterDelegate? { get set }
    
    func searchFilms(title: String)
    func saveFilms(data: [Film])

}

public class SearchPresenter: SearchPresenterProtocol {
    var searchFilms: [SearchFilm]?
    weak var delegate: SearchPresenterDelegate?
    private let dataTransferService: DataTransferService
    private let endpoints: MoviesEnpdoints
    
    public init(dataTransferService: DataTransferService, endpoints: MoviesEnpdoints) {
        self.dataTransferService = dataTransferService
        self.endpoints = endpoints
    }
    

    func searchFilms(title: String) {
        if !(title.isEmpty) {
        dataTransferService.request(with: endpoints.search(with: title)) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.results.map { item in
                    return Film(filmId: item.id, title: item.title, imageURL: URL(string: item.image))
                }
                self?.saveFilms(data: movies)
                self?.delegate?.updataData()
                
            case .failure(let error):
                print("Description error: \(error)")
            }
        }
        } else {
            searchFilms = []
            self.delegate?.updataData()
        }
        
    }
    
    func saveFilms(data: [Film]) {
        searchFilms?.removeAll()
        for i in 0...data.count - 1 {
            let title = data[i].title
            
            if let url: URL? = data[i].imageURL {
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        searchFilms?.append(SearchFilm(title: title, image: image))
                    }
                }
            }
        }
}
}
