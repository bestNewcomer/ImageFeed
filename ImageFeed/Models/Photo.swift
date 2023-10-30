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
    let user: ProfileResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case user
        case urls
    }
    
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
}

extension Photo {
    init(from result: PhotoResult) {
        self.init(
            id: result.id, 
            size: CGSize(width: result.width, height: result.height),
            createdAt: ISO8601DateFormatter().date(from: result.createdAt ?? ""),
            welcomeDescription: result.description ?? "",
            thumbImageURL: result.urls.thumb ?? "",
            largeImageURL: result.urls.full ?? "",
            isLiked: result.likedByUser)
    }
    
    struct LikeResult: Decodable {
        let photo: PhotoResult
    }
}

