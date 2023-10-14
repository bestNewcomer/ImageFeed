import UIKit

final class ProfileViewController: UIViewController {
    
    let imageView = UIImageView()
    let nameUser = UILabel()
    let idUser = UILabel()
    let statusUser = UILabel()
    let buttonLogout = UIButton()
    
    @objc
    func tapButtonLogout() {
    }
    
    private func image(){
        let profileImage = UIImage(named: "profile")
        imageView.image = profileImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func name(){
        
        nameUser.text = "Екатерина Новикова"
        nameUser.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameUser.textColor = .white
        nameUser.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameUser)
        nameUser.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameUser.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func id() {
        idUser.text = "@ekaterina_nov"
        idUser.font = UIFont(name: "System", size: 13)
        idUser.textColor = .gray
        idUser.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idUser)
        idUser.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        idUser.topAnchor.constraint(equalTo: nameUser.bottomAnchor, constant: 8).isActive = true
    }
    
    private func status() {
        statusUser.text = "Hello, world!"
        statusUser.font = UIFont(name: "System", size: 13)
        statusUser.textColor = .white
        statusUser.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusUser)
        statusUser.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        statusUser.topAnchor.constraint(equalTo: idUser.bottomAnchor, constant: 8).isActive = true
    }
    
    private func logout() {
        buttonLogout.setImage(UIImage(named: "exitButton"), for: .normal)
        buttonLogout.addTarget(self, action: #selector(self.tapButtonLogout), for: .touchUpInside)
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonLogout)
        buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        buttonLogout.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    
        image()
        name()
        id()
        status()
        logout()
    }
}
