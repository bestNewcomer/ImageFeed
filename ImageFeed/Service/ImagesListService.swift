import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private var currentTask: URLSessionTask?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let request = makeFetchPhotoRequest(page: nextPage, perPage: 10) else {
            assertionFailure("Не верный запрос")
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let photoResult):
                let photos = photoResult.map { Photo(from: $0) }
                self.photos.append(contentsOf: photos)
                self.lastLoadedPage = nextPage
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self
//                        userInfo: ["photos": self.photos]
                    )
            case .failure(let error):
                assertionFailure("Error - \(error)")
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}
extension ImagesListService {
    private func makeFetchPhotoRequest(page: Int, perPage: Int) -> URLRequest? {
        builder.makeHTTPRequest(
            path: ("/photos?"
                   + "page=\(page)"
                   + "&&per_page=\(perPage)"),
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseURL
        )
        
    }
}
