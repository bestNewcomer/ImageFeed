//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 10.10.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController:UIViewController {
    
    //MARK:  - IB Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    //MARK:  - Public Properties
    var image: URL?
//    var image: UIImage! {
//        didSet {
//            guard isViewLoaded else {return}
//            imageView.image = image
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
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
                print ("error")
                //self.showError()
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
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
