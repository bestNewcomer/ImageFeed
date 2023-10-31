
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    
    
    //MARK:  - IB Outlets
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    //MARK:  - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    //MARK:  - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageCell.kf.cancelDownloadTask()
    }
    
    //MARK:  - IB Actions
    @IBAction func clikLikeButton(_ sender: Any) {
        delegate?.clickLikeImage(self)
    }
    
    // MARK:  - Public Methods
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        likeButton.setImage(likeImage, for: .normal)
    }
}
