import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession: URLSession
    private let builder: URLRequestBuilder
    
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    init(
        urlSession: URLSession = .shared,
        builder: URLRequestBuilder = .shared) {
            self.urlSession = urlSession
            self.builder = builder
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Не верный запрос")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            self?.currentTask = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
    
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.baseURL
        )
        
    }
    
}
