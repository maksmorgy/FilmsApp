import Foundation
import UIKit
import CoreData

public protocol ListPresenterDelegate: AnyObject {
    func updateData()
}

protocol ListPresenterProtocol: AnyObject {
    var delegate: ListPresenterDelegate? {get set}
    
    func numberOfFilms() -> Int
    func saveFilms(title: String?, url: URL?)
    func filmAtIndex(index: Int) -> Film?
}

public class ListPresenter: ListPresenterProtocol {
    
    // MARK: - Properties
    public weak var delegate: ListPresenterDelegate?
    private let films: [Film]
    private var coreDataManager = CoreDataManager()
    
    // MARK: - Initialization
    init(coreDataManager: CoreDataManager, data: FilmsCollection) {
        self.coreDataManager = coreDataManager
        self.films = data.films
    }
    
    // MARK: - Action
    func filmAtIndex(index: Int) -> Film? {
        let film = films[index]
        return film
    }
    
    func saveFilms(title: String?, url: URL?) {
        let filmMO = FilmMO(context: self.coreDataManager.persistentContainer.viewContext)
        if let url: URL = url {
            if let data = try? Data(contentsOf: url) {
                filmMO.filmImage = data
                filmMO.filmTitle = title
                coreDataManager.saveContext()
            }
        }
    }
    
    func numberOfFilms() -> Int {
        return films.count 
    }
}
