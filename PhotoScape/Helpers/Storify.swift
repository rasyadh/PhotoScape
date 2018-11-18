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
    
    // MARK: Authentications
    func handleSuccessfullLogin() {
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.synchronize()
        
        Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": true])
    }
    
    func handleSuccessfullRegister() {
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.synchronize()
        
        Notify.post(name: NotifName.authRegister, sender: self, userInfo: ["success": true])
    }
    
    func storeUsers(_ info: JSON) {
        self.users = info.arrayValue.map { User($0) }
        print(self.users!)
        Notify.post(name: NotifName.fetchUsers, sender: self, userInfo: ["success": true])
    }
    
    func storePosts(_ info: JSON) {
        self.posts = info.arrayValue.map { Post($0) }
        print(self.posts!)
        Notify.post(name: NotifName.fetchPosts, sender: self, userInfo: ["success": true])
    }
}
