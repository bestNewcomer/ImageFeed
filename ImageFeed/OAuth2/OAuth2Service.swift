import Foundation

final class OAuth2Service {
    
    private let urlSession: URLSession
    private let storage: OAuth2TokenStorage
    private let builder: URLRequestBuilder
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
    init(
        urlSession: URLSession = .shared,
        storage: OAuth2TokenStorage = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.storage = storage
        self.builder = builder
    }
    
    // Метод загружает Токен по запросу
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
        assert(Thread.isMainThread)
        guard code != lastCode, currentTask != nil else {
            return
        }
        
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Не верный запрос")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            self?.currentTask = nil
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self?.storage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}

extension OAuth2Service {
    // Метод создает запрос в сеть
    private func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "\(Constants.baseAuthTokenPath)"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(Constants.code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.baseURL
        )
    }
}

