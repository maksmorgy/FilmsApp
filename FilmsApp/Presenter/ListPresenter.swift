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
    private var films: [Film]?
    
    func loadData(data: FilmsCollection) {
        self.films = data.films
//        guard let url: URL? = data.films[indexPath.row].imageURL else {return}
//        DispatchQueue.main.async { [weak self] in
//            if let data = try? Data(contentsOf: url as! URL) , let image = UIImage(data: data)  {
//                DispatchQueue.main.async {
//                    cell.updateAppearanceFor(content: self?.data.films[indexPath.row], image: image)
//                }
//            }
//        }
 }
    
    func titleAtindex(index: Int) -> String? {
        let title = films?[index].title
        return title
    }
    
    func imageAtindex(index: Int) -> UIImage? {
        var image: UIImage?
        DispatchQueue.main.async {
            guard let url: URL? = self.films?[index].imageURL else { return }
       
            guard let data = try? Data(contentsOf: url as! URL) else { return }
                image = UIImage(data: data)
            
        
       
       }
        return image
    }
    
    func idAtindex() {
        
    }
    
    func numberOffilms() -> Int {
        return 0
    }
    
}
