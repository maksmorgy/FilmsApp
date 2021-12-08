import Foundation

class NetworkManager {
    let filmURL = "https://api.themoviedb.org/3/movie/550?api_key=e2e4bcb7d129a3f2fc10147b899a604d"
    weak var delegate: FilmManagerDelegate?
    
    func fetchFilm(film: String) {
        //let urlString = "\(filmURL)&t=\(film)"
        let urlString = filmURL
        performeRequest(urlSttring: urlString)
    }
    
    func performeRequest(urlSttring: String) {
        if let url = URL(string: urlSttring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let film = self.parseJSON(filmData: safeData) {
                        self.delegate?.didUpdateData(film: film)
                        print("???????????????")
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
