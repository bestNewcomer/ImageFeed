import UIKit

final class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueId = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == ShowWebViewSegueId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Ошибка сигвея\(ShowWebViewSegueId)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
