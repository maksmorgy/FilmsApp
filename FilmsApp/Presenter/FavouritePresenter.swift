import Foundation
import CoreData

protocol FavouritePresenterDelegate: AnyObject {
    func updataData(data: [Film_Data])
}

protocol FavouritePresenterProtocol: AnyObject {
    var films: [Film_Data]? { get set }
    var delegate: FavouritePresenterDelegate? { get set }
    
    func loadFilms()
    func deleteFilm(data: Film_Data)
}

public class FavouritePresenter: FavouritePresenterProtocol {
    var films: [Film_Data]?
    weak var delegate: FavouritePresenterDelegate?
    let context = CoreDataManager.instance.persistentContainer.viewContext
    
    func loadFilms() {
        let request : NSFetchRequest<Film_Data> = Film_Data.fetchRequest()
        
        do{
            films = try context.fetch(request)
            delegate?.updataData(data: films!)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func deleteFilm(data: Film_Data) {
        CoreDataManager.instance.delete(film: data)
    }
}
