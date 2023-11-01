import UIKit

final class AuthViewController: UIViewController {
    
    //MARK:  - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK:  - Private Properties
    private let showWebViewSegueId = "ShowWebView"
    
    //MARK:  - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showWebViewSegueId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Ошибка сигвея\(showWebViewSegueId)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
