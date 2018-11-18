//
//  APIService.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIService {
    func fetchPopularPhoto() -> [JSON] {
        if let path = Bundle.main.path(forResource: "content", ofType: "json") {
            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            if let json = try? JSON(data: jsonData) {
                return json["photos"].arrayValue
            }
        }
        else {
            print("Cannot read JSON file")
            return [JSON]()
        }
        return [JSON]()
    }
    
    func fetchPhotos(completion: @escaping (_ photos: [Photo]?) -> Void) {
        if let path = Bundle.main.path(forResource: "content", ofType: "json") {
            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            if let json = try? JSON(data: jsonData) {
                let photos = json["photos"].arrayValue.map { Photo($0) }
                completion(photos)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func fetchAllUser(completion: @escaping (_ users: [User]?) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/users"
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let users = JSON(value).arrayValue.map { User($0) }
                completion(users)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
