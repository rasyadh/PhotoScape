//
//  HomeTabBarControllerViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 13/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabPhotos = UIStoryboard(name: "Photos", bundle: nil).instantiateInitialViewController()
        let tabPhotosItem = UITabBarItem(title: "Photos", image: UIImage(named: "photo"), tag: 0)
        tabPhotos?.tabBarItem = tabPhotosItem
        
        let tabPlaylist = UIStoryboard(name: "Playlist", bundle: nil).instantiateInitialViewController()
        let tabPlaylistItem = UITabBarItem(title: "Playlist", image: UIImage(named: "playlist"), tag: 1)
        tabPlaylist?.tabBarItem = tabPlaylistItem
        
        let tabUsers = UIStoryboard(name: "Users", bundle: nil).instantiateInitialViewController()
        let tabUsersItem = UITabBarItem(title: "Users", image: UIImage(named: "people"), tag: 2)
        tabUsers?.tabBarItem = tabUsersItem
        
        let tabPosts = UIStoryboard(name: "Posts", bundle: nil).instantiateInitialViewController()
        let tabPostsItem = UITabBarItem(title: "Posts", image: UIImage(named: "post"), tag: 3)
        tabPosts?.tabBarItem = tabPostsItem
        
        let tabProfile = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()
        let tabProfileItem = UITabBarItem(title: "Profile", image: UIImage(named: "user"), tag: 4)
        tabProfile?.tabBarItem = tabProfileItem
        
        self.viewControllers = [tabPhotos, tabPlaylist, tabUsers, tabPosts, tabProfile] as? [UIViewController]
    }
}
