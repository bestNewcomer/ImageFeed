//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var imagesListService: ImagesListService { get }
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike, { [weak self ] result in
            guard let self = self else { return }
            switch result{
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
            }
        })
    }
}
