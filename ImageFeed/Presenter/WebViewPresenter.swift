//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 31.10.2023.
//

import Foundation
import WebKit

public protocol WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    //MARK:  - Public Properties
    var authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?
    
    //MARK:  - Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    //MARK:  - Public Methods
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHiden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
}
