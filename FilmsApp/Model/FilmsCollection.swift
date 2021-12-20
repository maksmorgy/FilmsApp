import Foundation
import UIKit

struct FilmsCollection {
    let films: [Film]
}


struct Film {
    let title: String
    let image: String
}
struct Item: Codable {
    let title: String
    let image: String
}
public struct FilmsCategoryResponse: Codable {
    let results: [Item]
}

