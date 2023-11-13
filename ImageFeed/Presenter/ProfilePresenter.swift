//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 01.11.2023.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profile: Profile? { get }
    var avatarURL: URL? { get }
    
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    let profileImageService = ProfileImageService.shared
    let profileService = ProfileService.shared
    var avatarURL: URL? {
        profileImageService.avatarURL
    }
    var profile: Profile? {
        profileService.profile
    }
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                self.view?.updateAvatar(url: self.avatarURL)
            }
        view?.updateProfileDetails(profile: profileService.profile)
        view?.updateAvatar(url: avatarURL)
        profileImageService.fetchProfileImageURL(username: profile?.username ?? "")
        { _ in }
    }
}

