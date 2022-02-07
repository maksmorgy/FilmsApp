import Foundation
import UIKit

protocol ListPresenterDelegate {
    func updateData()
}

protocol ListPresenterProtocol {
    var delegate: ListPresenterDelegate? {get set}
    
    func loadData(data: FilmsCollection)
    func titleAtindex(index: Int) -> String?
    func imageAtindex(index: Int) -> UIImage?
    func idAtindex(index: Int) -> String?
    func numberOffilms() -> Int
    func saveFilms(title: String?, image: UIImage?)
}

public class ListPresenter: ListPresenterProtocol {
    var delegate: ListPresenterDelegate?
    var films: [Film]?
    // TODO: Remove unneeded property
    var images: [UIImage]?
    // TODO: Pass CoreDataManager via initializer
    let context = CoreDataManager.instance.persistentContainer.viewContext

    
    func loadData(data: FilmsCollection) {
        self.films = data.films
        delegate?.updateData()
    }
    
    // TODO: Replace methods below with "filmAtIndex" method
    
    func titleAtindex(index: Int) -> String? {
        let title = films?[index].title
        return title
    }
    
    func imageAtindex(index: Int) -> UIImage? {
        var image = UIImage()
        if let url: URL? = films?[index].imageURL {
            if let data = try? Data(contentsOf: url as! URL) {
                image = UIImage(data: data)!
            }
        }
        return image
    }
    
    func idAtindex(index: Int) -> String? {
        return self.films?[index].filmId
    }
    
    func saveFilms(title: String?, image: UIImage?) {
        let moFilm = MOFilm(context: self.context)
        moFilm.filmTitle = title
        // TODO: Remove forced unwrapping
        let data = image!.pngData()
        moFilm.filmImage = data
        CoreDataManager.instance.saveContext()
    }
    
    func numberOffilms() -> Int {
        return films?.count ?? 0
    }
    
}
