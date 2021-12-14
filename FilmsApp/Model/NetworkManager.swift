import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func performeRequest(completion: @escaping (Result<FilmsModel, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    //let filmURL = "https://api.themoviedb.org/3/movie/550?api_key=e2e4bcb7d129a3f2fc10147b899a604d"
    
//    func fetchFilm(film: String) {
//        let urlString = "\(filmURL)&t=\(film)"
//        let urlString = filmURL
//        performeRequest(urlSttring: urlString)
//    }
    
    func performeRequest( completion: @escaping (Result<FilmsModel, Error>) -> Void) {
        let urlSttring = "https://imdb-api.com/API/IMDbList/k_1aoi0vnf/ls093462543"
        if let url = URL(string: urlSttring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSON(filmData: safeData) {
                        //print(data)
                        completion(.success(data))
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(filmData: Data) -> FilmsModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(FilmData.self, from: filmData)
            let title = [decodedData.items[0].title]
            let urlImage = [decodedData.items[1].image]
            
            var myImage = [UIImage()]
            let url = URL(string: urlImage[0])!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    myImage[0] = image
                }
            }
            
            let film = FilmsModel(title: title, urlImage: myImage)
            print(film)
            return film
        } catch  {
            print(error)
            return nil
        }
    }
    
}
