import Foundation
import UIKit

public struct FilmsCollection {
    let films: [Film]
    let title: String
}

struct Film {
    let filmId: String
    let title: String
    let imageURL: URL?
}

struct DetailFilm {
    let id: String
    let title: String
    let genres: String
    let countries: String
    let imDBRating: String
}





