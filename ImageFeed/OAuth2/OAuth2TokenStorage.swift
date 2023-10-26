import Foundation

final class OAuth2TokenStorage {
    
    //MARK:  - Public Properties
    static let shared = OAuth2TokenStorage()
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
    //MARK:  - Initializers
    private init() {}

}
