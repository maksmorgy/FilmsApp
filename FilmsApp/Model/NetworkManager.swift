import Foundation

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
        let urlSttring = "https://api.themoviedb.org/3/movie/550?api_key=e2e4bcb7d129a3f2fc10147b899a604d"
        if let url = URL(string: urlSttring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    completion(.failure(error!))
                    //self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSON(filmData: safeData) {
                        print(data)
                        completion(.success(data))
                        //self.delegate?.didUpdateData(film: film)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(filmData: Data) -> FilmsModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(FilmsModel.self, from: filmData)
            let id = decodedData.id
            let title = decodedData.original_title
            let film = FilmsModel(id: id, original_title: title)
            return film
        } catch  {
            print(error)
            return nil
        }
    }
    
}
