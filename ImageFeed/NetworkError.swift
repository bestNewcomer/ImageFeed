import Foundation

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case decodingError(Error)
    case urlSessionError
    case invalidRequest
    
}
