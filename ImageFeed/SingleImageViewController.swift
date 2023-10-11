//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 10.10.2023.
//

import UIKit

final class SingleImageViewController:UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
