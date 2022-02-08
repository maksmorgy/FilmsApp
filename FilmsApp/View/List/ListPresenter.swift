import Foundation
import UIKit
import CoreData

protocol ListPresenterDelegate {
    func updateData()
}

protocol ListPresenterProtocol {
    var delegate: ListPresenterDelegate? {get set}
    
    func numberOffilms() -> Int
    func saveFilms(title: String?, url: URL?)
    func filmAtIndex(index: Int) -> Film?
}

public class ListPresenter: ListPresenterProtocol {
    
    // MARK: - Properties
    var delegate: ListPresenterDelegate?
    private let films: [Film]?
    private var managerCD = CoreDataManager()
    
    // MARK: - Initialization
    init(managerCD: CoreDataManager, data: FilmsCollection) {
        self.managerCD = managerCD
        self.films = data.films
    }
    
    // MARK: - Action
    func filmAtIndex(index: Int) -> Film? {
        let film = films?[index]
        return film
    }
    
    func saveFilms(title: String?, url: URL?) {
        let moFilm = MOFilm(context: self.managerCD.persistentContainer.viewContext)
        
        if let url: URL = url {
            if let data = try? Data(contentsOf: url) {
                moFilm.filmImage = data
                moFilm.filmTitle = title
                managerCD.saveContext()
            }
        }
    }
    
    func numberOffilms() -> Int {
        return films?.count ?? 0
    }
}
