
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dataLabel: UILabel!
}

extension ImagesListCell {
    func config(image: UIImage?, date: String, like: Bool) {
        imageCell.image = image
        dataLabel.text = date
        
        let imageLike = like ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        likeButton.setImage(imageLike, for: .normal)
    }
}
