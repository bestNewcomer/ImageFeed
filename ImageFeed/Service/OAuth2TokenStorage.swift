import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    //MARK:  - Public Properties
    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Constants.bearerToken)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Constants.bearerToken)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.bearerToken)
            }
        }
    }
    //MARK:  - Initializers
    private init() {}

}
