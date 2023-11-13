import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListViewControllerProtocol: AnyObject {
    
    var presenter: ImagesListPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    func updateTableViewAnimated()
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}
    
final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    //MARK:  - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK:  - Public Properties
    var photos: [Photo] = []
    lazy var presenter: ImagesListPresenterProtocol? = {
        return ImagesListPresenter()
    }()

    //MARK:  - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    //private let imagesListService = ImagesListService()
    private let placeholder = UIImage(named: "stubImage")
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        presenter?.view = self
        
    }
    
    //MARK:  - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifier,
            let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            super.prepare(for: segue, sender: sender)
            return
        }
        let imageName = photos[indexPath.row].largeImageURL
        let image = URL(string: imageName)
        viewController.image = image
    }
    
    //MARK:  - Public Methods
    func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = presenter?.imagesListService.photos.count else { return }
        guard let presenterPhotos = presenter?.imagesListService.photos else { return }
        photos = presenterPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        let photo = photos[indexPath.row]
        if let thumbImageUrl = URL(string: photo.thumbImageURL) {
            cell.imageCell.kf.indicatorType = .activity
            cell.imageCell.kf.setImage(with: thumbImageUrl, placeholder: placeholder) {
                [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    guard let presenterPhotos = self.presenter?.imagesListService.photos else { return }
                    if let created = photo.createdAt {
                        cell.dataLabel.text = DateFormatter.dateFormatter.string(from: created)
                    } else {
                        cell.dataLabel.text = ""
                    }
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    self.photos = presenterPhotos
                case .failure (let error):
                    print("Изображение не загружено: \(error)")
                    cell.imageCell.image = placeholder
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
    guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tableView.numberOfRows(inSection: 0) {
            presenter?.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func clickLikeImage (_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                guard let presenterPhotos = self.presenter?.imagesListService.photos else { return }
                self.photos = presenterPhotos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure (let error):
                UIBlockingProgressHUD.dismiss()
                let alert = UIAlertController(
                            title: "Что-то пошло не так!",
                            message: "\(error.localizedDescription)",
                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                            title: "Ок",
                            style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}






