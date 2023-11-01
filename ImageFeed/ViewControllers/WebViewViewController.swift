import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    //MARK:  - IB Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    //MARK:  - Public Properties
    var delegate: WebViewViewControllerDelegate?
    
    //MARK:  - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [], changeHandler: { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        })
    }
    
    //MARK:  - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    //MARK:  - Private Methods
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate{
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction){
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - extension WebViewViewController
private extension WebViewViewController {
    
    func loadWebView() {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: WebKeys.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebKeys.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: WebKeys.responseType, value: Constants.code),
            URLQueryItem(name: WebKeys.scope, value: Constants.accessScope)
        ]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
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
