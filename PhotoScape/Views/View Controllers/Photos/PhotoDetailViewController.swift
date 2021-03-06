//
//  PhotoDetailViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoDetailViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let imageUrl = imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}
