import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 1
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private var currentTask: URLSessionTask?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if currentTask != nil { return }
        currentTask?.cancel()
        
        guard let request = makeFetchPhotoRequest(lastLoadedPage, perPage: 10) else {
            assertionFailure("Не верный запрос")
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.currentTask = nil
            switch response {
            case .success(let photoResult):
                for photo in photoResult {
                    self.photos.append(Photo(from: photo))
                }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                self.lastLoadedPage += 1
            case .failure(let error):
                assertionFailure("Error - \(error)")
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}
extension ImagesListService {
    private func makeFetchPhotoRequest(_ page: Int, perPage: Int) -> URLRequest? {
        builder.makeHTTPRequest(
            path: ("/photos?"
                   + "page=\(page)"
                   + "&&per_page=\(perPage)"),
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseURL
        )
        
    }
}
