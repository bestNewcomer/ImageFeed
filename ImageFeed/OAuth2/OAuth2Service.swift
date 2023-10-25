import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage.shared
    private let builder = URLRequestBuilder.shared
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
   private init() {}
    
    
    var isAuthenticated: Bool {
        storage.token != nil
    }
    
    
    // Метод загружает Токен по запросу
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
//        guard !(code == lastCode && currentTask != nil) else {
//            return
//        }
        if code == lastCode { return }
        currentTask?.cancel()
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
                self?.lastCode = nil
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
            + "&&code=\(code)"
            //+ "&&code=\(Constants.code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURLString: Constants.baseURLString
        )
    }
}

