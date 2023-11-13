//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterUpdateAvatarCalled() {
        // given
        let viewController = ProfileViewControllerSpy2()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testPresenterUpdaseProfileDetailsCalled() {
        // given
        let viewController = ProfileViewControllerSpy2()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}
