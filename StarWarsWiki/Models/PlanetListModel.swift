import Foundation

//MARK: - Planet List Model
struct StarWarsPlanetList: Codable {
    let count: Int?
    let previous: String?
    let next: String?
    let planets: [Planet]
    enum CodingKeys: String, CodingKey {
        case count
        case previous
        case next
        case planets = "results"
    }
}

struct Planet: Codable {
    let name: String
    let diameter: String
    let climate: String
    let gravity: String
    let population: String
    let created: String
}
