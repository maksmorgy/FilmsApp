import Foundation

public protocol MoviesEnpdoints {
    func topMovies() -> Endpoint<MoviesResponse>
    func movies(with genre: String) -> Endpoint<FilmsCategoryResponse>
}

public final class DefaultMoviesEnpdoints: MoviesEnpdoints {
    let apiKey = "k_1aoi0vnf"
    
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
    var items: [Item]
}

struct MoviesQueries: Encodable {
    var genres: String
}
