//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//
@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListPresenterProtocol {
    var imagesListService: ImageFeed.ImagesListService
    var viewDidLoadCalled: Bool = false
    var didfetchPhotosNextPageCalled: Bool = false
    var didchangeLikeCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    
    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        didfetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didchangeLikeCalled = true
    }
}
