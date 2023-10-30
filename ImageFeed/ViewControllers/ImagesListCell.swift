
import UIKit

protocol ImagesListCellDelegate: AnyObject {
  
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    //MARK:  - IB Outlets
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    //MARK:  - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK:  - Overrides Methods
//    func config(image: UIImage?, date: String, like: Bool) {
//        imageCell.image = image
//        dataLabel.text = date
//        
//        let imageLike = like ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
//        likeButton.setImage(imageLike, for: .normal)
//        
//    }
}
