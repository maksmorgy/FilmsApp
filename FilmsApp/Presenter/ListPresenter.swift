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
    func idAtindex()
    func numberOffilms() -> Int
}

public class ListPresenter: ListPresenterProtocol {
    var delegate: ListPresenterDelegate?
    var films: [Film]?
    var images: [UIImage]?
    
    func loadData(data: FilmsCollection) {
        self.films = data.films
        delegate?.updateData()
    }
    
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
        delegate?.updateData()
    }
    
    func idAtindex() {
        
    }
    
    func numberOffilms() -> Int {
        return 0
    }
    
}
