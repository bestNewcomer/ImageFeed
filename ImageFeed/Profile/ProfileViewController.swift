import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var idUser: UILabel!
    @IBOutlet var statusUser: UILabel!
    @IBOutlet var buttonExit: UIButton!
    
    @IBAction func buttonLogout(_ sender: Any) {
    }
}
