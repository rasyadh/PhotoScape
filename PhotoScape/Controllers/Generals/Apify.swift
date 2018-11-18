//
//  Apify.swift
//  PhotoScape
//
//  Created by Twiscode on 12/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

enum RequestCode {
    case authLogin,
    authRegister,
    
    fetchPhotos,
    fetchUsers,
    fetchPosts
}

class Apify: NSObject {
    static let shared = Apify()
    
    private let JSONPLACEHOLDER_URL = "https://jsonplaceholder.typicode.com"
    private let API_GET_USERS = "/users"
    private let API_GET_POSTS = "/posts"
    
    // MARK: - Basic functions
    fileprivate func getHeaders(_ withAuthorization: Bool, accept: String? = nil) -> [String: String] {
        var headers = [String: String]()
        
        // Assign accept properties
        if accept == nil {
            headers["Accept"] = "application/json"
        }
        else {
            headers["Accept"] = accept
        }
        
        // Asign authorization properties
        if withAuthorization {
            if let token = UserDefaults.standard.string(forKey: Preferences.tokenLogin) {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        return headers
    }
    
    private func request(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) {
        // Save request data in case if request is failed due to expired token
        var requestData = [
            "url": url,
            "method": method,
            "code": code
        ] as [String: Any]
        if parameters != nil {
            requestData["parameters"] = parameters
        }
        if headers != nil {
            requestData["headers"] = headers
        }
        
        // Perform request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("[ Success ] Request Code: \(code)")
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = JSON(value)
                    self.consolidation(code, success: true, additionalData: responseJSON)
                    
                case .failure(let error):
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    print("[ ERROR ] : \(error)")
                    self.consolidation(code, success: false)
                }
        }
    }
    
    private func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: JSON? = nil) {
        switch requestCode {
        case .fetchUsers:
            if success {
                Storify.shared.storeUsers(additionalData!)
            }
            else {
                Notify.post(name: NotifName.fetchUsers, sender: self, userInfo: ["success": false])
            }
        case .fetchPosts:
            if success {
                Storify.shared.storePosts(additionalData!)
            }
            else {
                Notify.post(name: NotifName.fetchPosts, sender: self, userInfo: ["success": false])
            }
        // Default
        default:
            break
        }
    }
    
    func fetchUsers() {
        let url = JSONPLACEHOLDER_URL + API_GET_USERS
        request(url, method: .get, parameters: nil, headers: getHeaders(false), code: .fetchUsers)
    }
    
    func fetchPosts() {
        let url = JSONPLACEHOLDER_URL + API_GET_POSTS
        request(url, method: .get, parameters: nil, headers: getHeaders(false), code: .fetchPosts)
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
    
    func fetchPlaylist() {
        if let path = Bundle.main.path(forResource: "playlist", ofType: "json") {
            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            if let json = try? JSON(data: jsonData) {
                Storify.shared.storePlaylist(json)
            }
        }
        else {
            Notify.post(name: NotifName.fetchPlaylist, sender: self, userInfo: ["success": false])
        }
    }
    
    // MARK: - Authentications
    func login(parameters: [String: String]) {
        if parameters["email"]?.lowercased().hasSuffix("@photoscape.com") ?? false {
            Storify.shared.handleSuccessfullLogin(parameters)
        }
        else {
            Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": false])
        }
    }
    
    func register(parameters: [String: String]) {
        if parameters["email"]?.lowercased().hasSuffix("@photoscape.com") ?? false {
            Storify.shared.handleSuccessfullRegister(parameters)
        }
        else {
            Notify.post(name: NotifName.authRegister, sender: self, userInfo: ["success": false])
        }
    }
}
