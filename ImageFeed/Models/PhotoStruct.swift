import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let user: ProfileResult
    let urls: UrlsResult
    
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
    let isLiked: Bool
}
extension Photo {
    init(from result: PhotoResult) {
        self.init(
            id: result.id,
            size: CGSize(width: result.width, height: result.height),
            createdAt: DateFormatter.formatterDate.date(from: result.createdAt ?? ""),
            welcomeDescription: result.description ?? "",
            thumbImageURL: result.urls.thumb ?? "",
            largeImageURL: result.urls.full ?? "",
            isLiked: result.likedByUser
        )
    }
}
