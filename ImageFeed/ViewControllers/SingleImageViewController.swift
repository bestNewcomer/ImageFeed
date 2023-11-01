import UIKit
import Kingfisher
import ProgressHUD
final class SingleImageViewController:UIViewController {
    
    //MARK:  - IB Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    //MARK:  - Public Properties
    var image: URL?
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        showSingleImage()
    }
    
    //MARK:  - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    //MARK:  - Private Methods
    private func showSingleImage() {
        guard let imageURL = image else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [ weak self ] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let fullImage):
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 1.25
                self.rescaleAndCenterImageInScrollView(image: fullImage.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            })
        alert.addAction(UIAlertAction(
            title: "Не надо",
            style: .default) { [weak self] _ in
                self?.showSingleImage()
            })
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.size
            .width) / 2
        let halfHeight = (scrollView.bounds.size.height - imageView.frame.size
            .height) / 2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
    }
}
