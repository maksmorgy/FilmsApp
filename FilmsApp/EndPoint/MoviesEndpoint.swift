import Foundation

public protocol MoviesEnpdoints {
    func topMovies() -> Endpoint<MoviesResponse>
    func movies(with genre: String) -> Endpoint<FilmsCategoryResponse>
}

public final class DefaultMoviesEnpdoints: MoviesEnpdoints {
    // use keychain
   private let apiKey = "k_1aoi0vnf"
    
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
}

public struct MoviesResponse: Decodable {
    var items: [ItemDTO]
}

public struct FilmsCategoryResponse: Codable {
    let results: [ItemDTO]
}

struct ItemDTO: Codable {
    let image: String
    let title: String
   
}

struct MoviesQueries: Encodable {
    var genres: String
}
