//
//  ProfileViewPresenterSpy2.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy2: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateAvatarCalled: Bool = false
    var updateProfileDetailsCalled: Bool = false
    
    func updateAvatar(url: URL?) {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileDetailsCalled = true
    }
}
