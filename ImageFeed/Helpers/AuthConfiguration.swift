import UIKit

enum Constants {
    
    static let defaultApiBaseURL = "https://api.unsplash.com"
    static let baseURLString = "https://unsplash.com"
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let baseAuthTokenPath = "/oauth/token"
    static let authorizedPath = "/oauth/authorize/native"
    static let code = "code"
    
    static let accessKey = "GpwGcuFsl0st8sbpORR3J__4bYGasPj35Y7j5qqOH1w"
    static let secretKey = "skIhXSJSp8ENhI2bBsDZPsbz-Qt3hTBsjDLPJbdOFCk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let bearerToken = "bearerToken"
}

enum WebKeys {
    static let clientID: String = "client_id"
    static let redirectURI: String = "redirect_uri"
    static let responseType: String = "response_type"
    static let scope: String = "scope"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: String) {
        
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURL,
                                 defaultBaseURL: Constants.defaultApiBaseURL)
    }
}




