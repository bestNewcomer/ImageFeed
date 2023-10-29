
import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK:  - IB Outlets
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
    //MARK:  - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK:  - Overrides Methods
    func config(image: UIImage?, date: String, like: Bool) {
        imageCell.image = image
        dataLabel.text = date
        
        let imageLike = like ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        likeButton.setImage(imageLike, for: .normal)
    }
}
