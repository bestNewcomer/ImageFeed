import UIKit

enum Constants {
    // MARK: основные API адреса Usplash
    
    static let defaultBaseURL = "https://api.unsplash.com"
    static let baseURL = "https://unsplash.com"
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let baseAuthTokenPath = "/oauth/token"
    static let authorizedPath: String = "/oauth/authorize/native"
    static let code: String = "code"
    
    // MARK: API константы Usplash
    static let accessKey: String = "GpwGcuFsl0st8sbpORR3J__4bYGasPj35Y7j5qqOH1w"
    static let secretKey: String = "skIhXSJSp8ENhI2bBsDZPsbz-Qt3hTBsjDLPJbdOFCk"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    //MARК: константы
    
    static let bearerToken = "bearerToken"
}

enum WebKeys {
    static let clientID: String = "client_id"
    static let redirectURI: String = "redirect_uri"
    static let responseType: String = "response_type"
    static let scope: String = "scope"
}
