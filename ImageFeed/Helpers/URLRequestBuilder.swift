import Foundation

final class URLRequestBuilder {
    
    static let shared = URLRequestBuilder()
    private let storage = OAuth2TokenStorage.shared
    
    private init () {}
    
    func makeHTTPRequest(path: String,httpMethod: String,baseURLString: String) -> URLRequest? {
        guard
            let url = URL(string: baseURLString),
            let baseUrl = URL(string: path, relativeTo: url)
        else {return nil}
        
        var request = URLRequest (url:baseUrl)
        request.httpMethod = httpMethod
        
        if let token = storage.token {
            request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
    

