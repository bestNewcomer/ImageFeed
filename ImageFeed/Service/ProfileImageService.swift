import Foundation

final class ProfileImageService {
    
    //MARK:  - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK:  - Private Properties
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private (set) var avatarURL: URL?
    private var currentTask: URLSessionTask?
    
//    //MARK:  - Initializers
//    private init() {}
    
    //MARK:  - Public Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Не верный запрос")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success(let profilePhoto):
                    guard let mediumPhoto = profilePhoto.profileImage?.medium else { return }
                    self.avatarURL = URL(string: mediumPhoto)
                    completion(.success(mediumPhoto))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": mediumPhoto])
                case .failure(let error):
                    completion(.failure(error))
                }
                self.currentTask = nil
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}

// MARK: - extension ProfileService
extension ProfileImageService {
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseURL
        )
    }
}
