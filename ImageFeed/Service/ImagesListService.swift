import Foundation

final class ImagesListService {
    
    //MARK:  - Public Properties
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    //MARK:  - Private Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let urlSession = URLSession.shared
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    //MARK:  - Public Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let request = makeFetchPhotoRequest(page: nextPage, perPage: 10) else {
            assertionFailure("Не верный запрос")
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success(let photoResult):
                    let photos = photoResult.map { Photo(from: $0) }
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: nil
                        )
                case .failure(let error):
                    assertionFailure("Error - \(error)")
                }
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeFetchLikeRequest(photoID: photoId, isLike: isLike) else {
            assertionFailure("Ошибка лайка!))")
            return
        }
        
        let currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<[LikeResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let result = self.photos[index]
                        let newPhoto = Photo(
                            id: result.id,
                            size: result.size,
                            createdAt: result.createdAt,
                            welcomeDescription: result.welcomeDescription,
                            thumbImageURL: result.thumbImageURL,
                            largeImageURL: result.largeImageURL,
                            isLiked: !result.isLiked
                        )
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.currentTask = currentTask
        currentTask.resume()
    }
}

// MARK: - extension ImagesListService
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
    
    private func makeFetchLikeRequest(photoID: String, isLike: Bool) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/photos/\(photoID)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURLString: Constants.defaultBaseURL
        )
    }
}
