//
//  Artist.swift
//  PhotoScape
//
//  Created by Twiscode on 16/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Artists {
    let artists: [Artist]
}

struct Artist {
    let name: String
    let image: String
    
    init(_ data: JSON) {
        self.name = data["name"].string ?? ""
        self.image = data["image"].string ?? ""
    }
}
