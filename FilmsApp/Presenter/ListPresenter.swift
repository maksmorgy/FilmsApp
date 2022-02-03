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
    private var image: UIImage?
    
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
        if let url: URL? = films?[index].imageURL {
            
                if let data = try? Data(contentsOf: url as! URL) {
                    self.image = UIImage(data: data)
                    print(self.image)
                }
            
        }
        return self.image
    }
    
    func idAtindex() {
        
    }
    
    func numberOffilms() -> Int {
        return 0
    }
    
}
