import Foundation

struct StarWarsApiClient {
    //MARK: - Properties
    static private let filmEndPoint = "https://swapi.co/api/films/"
    static private let peopleEndPoint = "https://swapi.co/api/people/"
    static private let planetEndPoint = "https://swapi.co/api/planets/"
    static private var request: URLRequest!
    static private let session = URLSession.shared
    private init(){}
    
    //MARK: - Helper Methods
    static public func fetchFilms(callBack:@escaping( Result<[Film],NetworkError>)->Void){
        guard let url = URL(string: filmEndPoint) else {
            callBack(.failure(.badURl))
            return
        }
        request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let film = try JSONDecoder().decode(StarWarsFilmList.self, from: data)
                    callBack(.success(film.swFilms))
                } catch {
                    callBack(.failure(.jsonDecodeError(error)))
                }
            }
            if let error = error {
                callBack(.failure(.apiError(error)))
            }
        }
        task.resume()
    }
    
    static public func fetchPeople(callBack:@escaping( Result<[Person],NetworkError>)->Void){
        guard let url = URL(string: peopleEndPoint) else {
            callBack(.failure(.badURl))
            return
        }
        request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let people = try JSONDecoder().decode(StarWarsPeopleList.self, from: data)
                    callBack(.success(people.people))
                } catch {
                    
                    callBack(.failure(.jsonDecodeError(error)))
                }
            }
            if let error = error {
                callBack(.failure(.apiError(error)))
            }
        }
        task.resume()
    }

    static public func fetchPeoplePerMovie(endPointUrl endpoint: String, callBack:@escaping( Result<[Film],NetworkError>)->Void){
        guard let url = URL(string: endpoint) else {
        callBack(.failure(.badURl))
        return
        }
        request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let film = try JSONDecoder().decode(StarWarsFilmList.self, from: data)
                    callBack(.success(film.swFilms))
                } catch {
                    callBack(.failure(.jsonDecodeError(error)))
                }
            }
            if let error = error {
                callBack(.failure(.apiError(error)))
            }
        }
        task.resume()
        
    }

    static public func fetchPlanets(callBack:@escaping( Result<[Planet],NetworkError>)->Void){
        guard let url = URL(string: planetEndPoint) else {
            callBack(.failure(.badURl))
            return
        }
        request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let planet = try JSONDecoder().decode(StarWarsPlanetList.self, from: data)
                    callBack(.success(planet.planets))
                } catch {
                    callBack(.failure(.jsonDecodeError(error)))
                }
            }
            if let error = error {
                callBack(.failure(.apiError(error)))
            }
        }
        task.resume()
    }
}

