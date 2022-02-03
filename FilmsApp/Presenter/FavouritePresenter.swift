import Foundation
import CoreData

protocol FavouritePresenterDelegate: AnyObject {
    func updataData(data: [MOFilm])
}

protocol FavouritePresenterProtocol: AnyObject {
    var delegate: FavouritePresenterDelegate? { get set }
    
    func loadFilms()
    func deleteFilm(data: MOFilm, index: Int)
    func filmAtindex(index: Int) -> MOFilm?
    func numbersOfFilms() -> Int
}

public class FavouritePresenter: FavouritePresenterProtocol {
    private var films: [MOFilm]?
    weak var delegate: FavouritePresenterDelegate?
    private let context = CoreDataManager.instance.persistentContainer.viewContext
    
    func loadFilms() {
        let request : NSFetchRequest<MOFilm> = MOFilm.fetchRequest()
        
        do{
            films = try context.fetch(request)
            delegate?.updataData(data: films!)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func filmAtindex(index: Int) -> MOFilm? {
        let film = films?[index]
        return film
    }
    
    func numbersOfFilms() -> Int {
        return films?.count ?? 0
    }
    
    func deleteFilm(data: MOFilm, index: Int) {
        self.films?.remove(at: index)
        CoreDataManager.instance.delete(film: data)
    }
}
