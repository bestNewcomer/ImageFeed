import UIKit

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthentication"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Неверная конфигурация") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Неудалось подготовиться к \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code){ [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let token):
                self.switchToTabBarController()
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure (let error):
                //AlertPresenter(onViewController: self).showAlert(alertError: error)
                assertionFailure(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11]
                break
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { response in
            switch response {
            case .success:
                //self.fetchProfileImageURL(username: profile.username)
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
               // AlertPresenter(onViewController: self).showAlert(alertError: error)
                //assertionFailure(error.localizedDescription)
                break
            }
        }
    }
    
//    func fetchProfileImageURL(username: String) {
//        profileImageService.fetchProfileImageURL(username: username){ [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let succes):
//                let avatarURL = succes
//                //TODO: need to load image
//            case .failure(let error):
//                AlertPresenter(onViewController: self).showAlert(alertError: error)
//                print(error.localizedDescription)
//            }
//        }
//    }
}
