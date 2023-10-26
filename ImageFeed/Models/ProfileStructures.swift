import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(result profile: ProfileResult) {
        self.init(
            username: profile.username,
            name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName: "@\(profile.username)",
            bio: profile.bio
            )
    }
}

struct UserResult: Codable {
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}



