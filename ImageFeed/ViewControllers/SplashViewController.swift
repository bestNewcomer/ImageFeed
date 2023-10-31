import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    //MARK:  - Private Properties
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthentication"
    private var splashImage: UIImageView = {
        let splashImage = UIImageView(image: UIImage(named: "Vector"))
        splashImage.backgroundColor = .clear
        splashImage.contentMode = .scaleAspectFit
        return splashImage
    }()
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        alertPresenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
    }
    
    //MARK:  - Private Methods
    private func checkAuthStatus () {
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            fetchProfile { [ weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            showAuthViewController()
        }
    }
    
    private func showAuthViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated:  true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Неверная конфигурация") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func presentAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated:  true)
    }
    
    private func showLoginAlert(error: Error) {
                alertPresenter.showAlert(title: "Что-то пошло не так :(",
                                         message: "Не удалось войти в ситему,\(error.localizedDescription)") {
                    self.performSegue(withIdentifier: self.showAuthenticationScreenSegueIdentifier, sender: nil)
                }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code){ [weak self] authResult in
            switch authResult {
            case .success(_):
                self?.fetchProfile(completion: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure (let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile() { [weak self] profileResult in
            switch profileResult {
            case .success(_):
                guard let username = self?.profileService.profile?.username else { return }
                self?.profileImageService.fetchProfileImageURL(username: username) { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
            completion()
        }
    }
}

