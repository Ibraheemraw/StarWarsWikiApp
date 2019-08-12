import Foundation

//MARK: - Film List Model
struct StarWarsFilmList: Codable {
    let count: Int
    let previous: String?
    let next: String?
    let swFilms: [Film]
    enum CodingKeys: String, CodingKey {
        case count
        case previous
        case next
        case swFilms = "results"
    }
}

struct Film: Codable  {
    let title: String
    let episodeNum: Int
    let openingIntro: String
    let director: String
    let producer: String
    let releaseDate: String
    let characters: [String]
    enum CodingKeys: String, CodingKey {
        case title
        case episodeNum = "episode_id"
        case openingIntro = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case characters
    }
}
