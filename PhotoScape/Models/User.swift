//
//  User.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Users {
    let users: [User]
}

struct User {
    let name: String
    let email: String
    let phone: String
    
    init(_ data: JSON) {
        self.name = data["name"].string ?? ""
        self.email = data["email"].string ?? ""
        self.phone = data["phone"].string ?? ""
    }
}
