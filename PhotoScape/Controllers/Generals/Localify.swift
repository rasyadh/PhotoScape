//
//  Localify.swift
//  PhotoScape
//
//  Created by Twiscode on 16/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

enum LanguageName: String {
    case english = "en",
    bahasaIndonesia = "id"
}

class Localify: NSObject {
    static let shared = Localify()
    private var languageBundle: Bundle!
    var languageIdentifier = ""
    
    func setLanguage(_ name: LanguageName) {
        let path = Bundle.main.path(forResource: name.rawValue, ofType: ".lproj")!
        let bundle = Bundle(path: path)!
        languageBundle = bundle
        languageIdentifier = name == .english ? "en_US" : "id_ID"
    }
    
    static func get(_ key: String) -> String {
        return NSLocalizedString(key, bundle: Localify.shared.languageBundle, comment: "")
    }
}
