import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    //MARK:  - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    private init() {}
    
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
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}
extension ProfileService {
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseURL
        )
        
    }
}


