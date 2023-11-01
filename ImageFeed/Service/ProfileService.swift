import UIKit
import WebKit
import SwiftKeychainWrapper

final class ProfileService {
    
    //MARK:  - Public Properties
    static let shared = ProfileService()
    
    //MARK:  - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    //MARK:  - Initializers
    private init() {}
    
    //MARK:  - Public Methods
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Не верный запрос")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
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
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
    
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        KeychainWrapper.standard.removeObject(forKey: Constants.bearerToken)
    }
}

// MARK: - extension ProfileService
extension ProfileService {
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseURL
        )
        
    }
}


