import Foundation

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
