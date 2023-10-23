import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.bearerToken)
        }

        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: Constants.bearerToken)
        }
    }

}
