//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//
@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testImagesListViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let imagesListService = ImagesListService()
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testChangeLikeCalled() {
        // given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let viewController = ImagesListViewControllerSpy(photos: photos)
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.changeLike()
        
        // then
        XCTAssertTrue(presenter.didchangeLikeCalled)
    }
    
    func testDidFetchPhotosNextPageCalled() {
        //given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImagesListViewControllerSpy(photos: photos)
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view  //behaviour verification
        
        //when
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        //then
        XCTAssertTrue(presenter.didfetchPhotosNextPageCalled) //behaviour verification
    }
}
