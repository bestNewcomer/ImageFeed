import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.bearerToken)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: Constants.bearerToken)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.bearerToken)
            }
        }
    }

}
