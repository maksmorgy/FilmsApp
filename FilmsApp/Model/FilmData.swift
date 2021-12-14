
import Foundation

struct FilmData: Codable {
    let title: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let image: String
}
