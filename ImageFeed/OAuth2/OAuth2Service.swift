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
        //        if lastCode == code { return }
        //        currentTask?.cancel()
        
        currentTask = session.data(request: request) { [weak self] response in
            self?.currentTask = nil
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self?.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
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
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.baseURL
        )
    }
}

