//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var profile: ImageFeed.Profile?
    var avatarURL: URL?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
