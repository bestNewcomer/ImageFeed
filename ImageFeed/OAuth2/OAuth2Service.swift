import Foundation

final class OAuth2Service {
    
    private let session = URLSession.shared
    private let builder: URLRequestBuilder
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    // Делаем POST-запрос
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
        assert(Thread.isMainThread)
        if lastCode == code { return }
        
        currentTask?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        currentTask = object(for: request!) { [weak self] result in
            self?.currentTask = nil
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self?.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
}

extension OAuth2Service {
    
    private func object(for request: URLRequest,completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    private func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "\(Constants.baseAuthTokenPath)"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.baseURL
        )
    }
}
