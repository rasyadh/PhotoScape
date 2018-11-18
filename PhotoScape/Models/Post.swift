//
//  Post.swift
//  PhotoScape
//
//  Created by Twiscode on 12/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Posts {
    let posts: [Post]
}

struct Post {
    let id: Int?
    let title: String?
    let body: String?
    
    init(_ data: JSON) {
        self.id = data["id"].int ?? 0
        self.title = data["title"].string ?? ""
        self.body = data["body"].string ?? ""
    }
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}
