import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK:  - Private Properties
    private let profileService = ProfileService.shared
    
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "profile"))
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
    
    @objc
    private func tapLogoutButton() {
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSubView()
        applyConstraints()
        updateProfileDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //updateProfileDetails()
    }
    
    //MARK:  - Private Methods
    private func addSubView(){
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func applyConstraints(){
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
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
