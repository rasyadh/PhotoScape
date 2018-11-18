//
//  StoryHelper.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Preferences {
    static let isLoggedIn = "is_logged_in"
    static let tokenLogin = "token_login"
    static let userData = "user_data"
}

class Storify: NSObject {
    static let shared = Storify()
    var users: [User]? = [User]()
    var posts: [Post]? = [Post]()
    var albums: [Album]? = [Album]()
    var artists: [Artist]? = [Artist]()
    
    // MARK: Authentications
    func handleSuccessfullLogin(_ parameters: [String: String]) {
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.set(parameters, forKey: Preferences.userData)
        pref.synchronize()
        
        Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": true])
    }
    
    func handleSuccessfullRegister(_ parameters: [String: String]) {
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.set(parameters, forKey: Preferences.userData)
        pref.synchronize()
        
        Notify.post(name: NotifName.authRegister, sender: self, userInfo: ["success": true])
    }
    
    func storeUsers(_ info: JSON) {
        self.users = info.arrayValue.map { User($0) }
        Notify.post(name: NotifName.fetchUsers, sender: self, userInfo: ["success": true])
    }
    
    func storePosts(_ info: JSON) {
        self.posts = info.arrayValue.map { Post($0) }
        Notify.post(name: NotifName.fetchPosts, sender: self, userInfo: ["success": true])
    }
    
    func storePlaylist(_ info: JSON) {
        self.albums = info["albums"].arrayValue.map { Album($0) }
        self.artists = info["artists"].arrayValue.map { Artist($0) }
        Notify.post(name: NotifName.fetchPlaylist, sender: self, userInfo: ["success": true])
    }
}
