import Foundation
import CoreData

protocol FavouritePresenterDelegate: AnyObject {
    func updataData(data: [FilmMO])
}

protocol FavouritePresenterProtocol: AnyObject {
    var delegate: FavouritePresenterDelegate? { get set }
    
    func loadFilms()
    func deleteFilm(data: FilmMO, index: Int)
    func filmAtindex(index: Int) -> FilmMO?
    func numbersOfFilms() -> Int
}

public class FavouritePresenter: FavouritePresenterProtocol {
    
    // MARK: - Properties
    private var films: [FilmMO]?
    weak var delegate: FavouritePresenterDelegate?
    private var coreDataManager = CoreDataManager()
    
    // MARK: - Initialization
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Action
    func loadFilms() {
        let request : NSFetchRequest<FilmMO> = FilmMO.fetchRequest()
        
        do{
            films = try coreDataManager.persistentContainer.viewContext.fetch(request)
            delegate?.updataData(data: films!)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func filmAtindex(index: Int) -> FilmMO? {
        let film = films?[index]
        return film
    }
    
    func numbersOfFilms() -> Int {
        return films?.count ?? 0
    }
    
    func deleteFilm(data: FilmMO, index: Int) {
        films?.remove(at: index)
        coreDataManager.delete(film: data)
    }
}
