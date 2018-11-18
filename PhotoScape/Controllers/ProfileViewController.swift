//
//  ProfileViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile"
    }
    
    override func viewDidLayoutSubviews() {
        logoutButton.layer.cornerRadius = 5
    }

    // MARK: - Action
    @IBAction func authLogout(_ sender: Any) {
        let pref = UserDefaults.standard
        if pref.bool(forKey: Preferences.isLoggedIn) {
            pref.set(false, forKey: Preferences.isLoggedIn)
            pref.synchronize()
            
            managerViewController?.showLoginScreen(isFromLogout: true)
        }
    }
    
}
