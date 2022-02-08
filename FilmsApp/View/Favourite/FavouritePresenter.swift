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
    
    // MARK: - Properties
    private var films: [MOFilm]?
    weak var delegate: FavouritePresenterDelegate?
    private var managerCD = CoreDataManager()
    
    // MARK: - Initialization
    init(managerCD: CoreDataManager) {
        self.managerCD = managerCD
    }
    
    // MARK: - Action
    func loadFilms() {
        let request : NSFetchRequest<MOFilm> = MOFilm.fetchRequest()
        
        do{
            films = try managerCD.persistentContainer.viewContext.fetch(request)
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
        managerCD.delete(film: data)
    }
}
