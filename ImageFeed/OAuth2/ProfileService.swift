import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private let session = URLSession.shared
    private let builder: URLRequestBuilder
    
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        currentTask?.cancel()
        let request = makeFetchProfileRequest(token: token)
        currentTask = fetch(for: request!) { [weak self] result in
            self?.currentTask = nil
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetch(for request: URLRequest,completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    func data(for request: URLRequest,completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    private func makeFetchProfileRequest(token: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.baseURL
        )
        
    }
    
}
