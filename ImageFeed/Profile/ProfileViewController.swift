import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "profile"))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        return label
    }()
    private var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .gray
        return label
    }()
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .white
        return label
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "exitButton"), for: .normal)
        button.addTarget(ProfileViewController.self, action: #selector(tapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    
    private func addSubView(){
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(statusLabel)
        view.addSubview(logoutButton)
    }
    
    private func applyConstraints(){
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
            statusLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    @objc
    func tapLogoutButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
    
        addSubView()
        applyConstraints()
    }
}
