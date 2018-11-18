//
//  Album.swift
//  PhotoScape
//
//  Created by Twiscode on 13/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Albums {
    let albums: [Album]
}

struct Album {
    let image: String
    let name: String
    let detail: String
    
    init(_ data: JSON) {
        self.image = data["image"].string ?? ""
        self.name = data["name"].string ?? ""
        self.detail = data["detail"].string ?? ""
    }
}
