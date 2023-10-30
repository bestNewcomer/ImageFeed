import Foundation

struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = DateFormatter().date(from: result.createdAt ?? "")
        self.welcomeDescription = result.description ?? ""
        self.thumbImageURL = result.urls.thumb ?? ""
        self.largeImageURL = result.urls.full ?? ""
        self.isLiked = result.likedByUser
    }
}
