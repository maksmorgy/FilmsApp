import Foundation

public protocol FilmsEnpdoints {
    func topFilms() -> Endpoint<FilmsResponse>
    func films(with genre: String) -> Endpoint<FilmsCategoryResponse>
    func film(with filmId: String) -> Endpoint<SummaryFilmResponse>
}

public final class DefaultFilmsEnpdoints: FilmsEnpdoints {
    //private let apiKey = "k_1aoi0vnf"
    private let apiKey = "k_44hm08xm"
    //private let apiKey = ""
    //private let apiKey = "k_5bqobx4j"
    public func topFilms() -> Endpoint<FilmsResponse> {
        return .init(
            path: "/API/Top250Movies/\(apiKey)",
            method: .get
        )
    }
    
    public func films(with genre: String) -> Endpoint<FilmsCategoryResponse> {
        let queries = FilmsQueries(genres: genre)
        return .init(
            path: "/API/AdvancedSearch/\(apiKey)",
            queries: queries,
            method: .get
        )
    }
    
    public func film(with filmId: String) -> Endpoint<SummaryFilmResponse> {
        return .init(
            path: "/API/Title/\(apiKey)/\(filmId)",
            method: .get
        )
    }
}

public struct FilmsResponse: Decodable {
    var items: [ItemDTO]
}

public struct FilmsCategoryResponse: Codable {
    let results: [ItemDTO]
}

public struct SummaryFilmResponse: Codable {
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

struct FilmsQueries: Encodable {
    var genres: String
}
