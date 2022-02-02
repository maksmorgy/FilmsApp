import Foundation

public protocol MoviesEnpdoints {
    func topMovies() -> Endpoint<MoviesResponse>
    func movies(with genre: String) -> Endpoint<FilmsCategoryResponse>
    func movie(with filmId: String) -> Endpoint<SummaryFilmResponse>
}

public final class DefaultMoviesEnpdoints: MoviesEnpdoints {
    //private let apiKey = "k_1aoi0vnf"
   //private let apiKey = "k_44hm08xm"
    private let apiKey = ""
    
    public func topMovies() -> Endpoint<MoviesResponse> {
        return .init(
            path: "/API/Top250Movies/\(apiKey)",
            method: .get
        )
    }
    
    public func movies(with genre: String) -> Endpoint<FilmsCategoryResponse> {
        let queries = MoviesQueries(genres: genre)
        return .init(
            path: "/API/AdvancedSearch/\(apiKey)",
            queries: queries,
            method: .get
        )
    }
    
    public func movie(with filmId: String) -> Endpoint<SummaryFilmResponse> {
        return .init(
            path: "/API/Title/\(apiKey)/\(filmId)",
            method: .get
        )
    }
}

public struct MoviesResponse: Decodable {
    var items: [ItemDTO]
}

public struct FilmsCategoryResponse: Codable {
    let results: [ItemDTO]
}

public struct SummaryFilmResponse: Codable {
    //let image: String
    let id: String?
    let title: String?
    let genres: String?
    let countries: String?
    let imDbRating: String?
    let image: String?
}

struct ItemDTO: Codable {
    let id: String
    let image: String
    let title: String
   
}

struct MoviesQueries: Encodable {
    var genres: String
}
