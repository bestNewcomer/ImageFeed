//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 31.10.2023.
//

import Foundation

protocol AuthHelperProtocol {
    
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    
    //MARK:  - Public Properties
    let configuration: AuthConfiguration
    
    //MARK:  - Initializers
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    //MARK:  - Public Methods
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants.authorizedPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == Constants.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
