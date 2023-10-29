import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK:  - Private Properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var profileImage: UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "Avatar"))
        profileImage.backgroundColor = .clear
//        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
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
        let button = UIButton()
        button.setImage(UIImage(named: "exitButton"), for: .normal)
        button.addTarget(ProfileViewController.self, action: #selector(tapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        applyConstraints()
        updateProfileDetails()
        profileImageObsserver()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        profileImageObsserver()
//    }
    
    //MARK:  - Private Methods
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
    }
    
    private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        updateAvatar(url: url)
    }
    
    private func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 70, backgroundColor: .clear)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "avatar_placeholder"), options: [.processor(processor)])
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile
        else { assertionFailure("Нет сохраненного профиля")
            return }
        self.nameLabel.text = profile.name
        self.idLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
}

private extension ProfileViewController {
    func profileImageObsserver() {
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main){
            [weak self] notification in self?.updateAvatar(notification: notification)
        }
    }
}