import Foundation

//MARK: - People List Model
struct StarWarsPeopleList: Codable {
    let count: Int?
    let previous: String?
    let next: String?
    let people: [Person]
    enum CodingKeys: String, CodingKey {
        case count
        case previous
        case next
        case people = "results"
    }
}

struct Person: Codable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let created: String
    enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
        case homeworld
        case created
    }
}
