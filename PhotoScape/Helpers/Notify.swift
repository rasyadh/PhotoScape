//
//  NotificationHelper.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

struct NotifName {
    static let authLogin = Notification.Name("auth_login")
    static let authRegister = Notification.Name("auth_register")
    static let fetchUsers = Notification.Name("fetch_users")
    static let fetchPosts = Notification.Name("fetch_posts")
}

class Notify: NSObject {
    static let shared = Notify()
    
    // Instance var
    fileprivate var listener = [NSObject]()
    
    // MARK: - Static Method
    static func post(name: Notification.Name, sender: NSObject? = nil, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: (sender == nil ? self : sender), userInfo: userInfo)
    }
    
    // MARK: - Public Methods
    func listen(_ sender: NSObject, selector: Selector, name: Notification.Name? = nil, object: Any? = nil) {
        NotificationCenter.default.addObserver(sender, selector: selector, name: name, object: object)
        listener.append(sender)
    }
    
    func removeListener(_ listener: NSObject, name: Notification.Name? = nil, object: Any? = nil) {
        if let index = self.listener.index(where: {$0 == listener}) {
            self.listener.remove(at: index)
            NotificationCenter.default.removeObserver(listener, name: name, object: object)
        }
    }
    
    func removeAllListener() {
        let nCenter = NotificationCenter.default
        for anObject in listener {
            nCenter.removeObserver(anObject)
        }
        listener.removeAll()
    }
}
