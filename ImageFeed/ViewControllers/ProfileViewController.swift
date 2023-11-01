import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    func updateAvatar(url: URL?)
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
   
    //MARK:  - Private Properties
    lazy var presenter: ProfilePresenterProtocol = ProfilePresenter(view: self)
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var profileImage: UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "Avatar"))
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .gray
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .white
        return label
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(
        with: UIImage(named: "exitButton")!,
        target: ProfileViewController?.self,
                      action: #selector(Self.tapLogoutButton))
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "exitButton"
        return button
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
        presenter.viewDidLoad()
        addSubView()
        applyConstraints()
    }
    
    //MARK:  - Public Methods
    func updateAvatar(url: URL?) {
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "avatar_placeholder"))
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile
        else { assertionFailure("Нет сохраненного профиля")
            return }
        self.nameLabel.text = profile.name
        self.idLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    //MARK:  - Private Methods
    private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        updateAvatar(url: url)
    }
    
    private func addSubView(){
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func applyConstraints(){
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
    
    @objc
    private func tapLogoutButton() {
        let alert = UIAlertController(
                    title: "Пока, пока!",
                    message: "Уверены что хотите выйти?",
                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                    title: "Да",
                    style: .default){ _ in
                        self.profileService.clean()
                        self.present(SplashViewController(), animated: true)
                    })
        alert.addAction(UIAlertAction(
                    title: "Нет",
                    style: .default) { _ in
                        self.dismiss(animated: true)
                    })
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

