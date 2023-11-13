//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//
import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        
    }
}

