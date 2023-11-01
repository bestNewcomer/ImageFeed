import Foundation

protocol ImagesListCellDelegate: AnyObject {
    
    func clickLikeImage (_ cell: ImagesListCell)
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
