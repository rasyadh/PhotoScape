//
//  Photo.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    var id: Int
    var name: String
    var rating: Float
    var image_url: String
    
    init(_ data: JSON) {
        self.id = data["id"].int ?? 0
        self.name = data["name"].string ?? ""
        self.rating = data["rating"].float ?? 0.0
        self.image_url = data["image_url"].string ?? ""
    }
}
