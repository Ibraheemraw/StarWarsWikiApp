import Foundation

enum NetworkError: Error {
    case badURl
    case badStatusCode
    case apiError(Error)
    case jsonDecodeError(Error)
}

