//
//  ManagerViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

public class ManagerViewController: UIViewController {

    private var authStoryboard: UIStoryboard?
    
    private var cachedViewController = [String: UIViewController]()
    private var activeViewControllerId = ""
    
    private let CHILD_KEY = 1000000
    private let CHILD_LOGIN_KEY = "AuthInitial"
    private let CHILD_HOME_KEY = "HomeTabBarController"
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let pref = UserDefaults.standard
        if pref.bool(forKey: Preferences.isLoggedIn) {
            showHomeScreen()
        }
        else {
            showLoginScreen(isFromLogout: false)
        }
        // Do any additional setup after loading the view.
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let activeVC = cachedViewController[activeViewControllerId]
        cachedViewController.removeAll()
        cachedViewController[activeViewControllerId] = activeVC
    }
    
    public func showLoginScreen(isFromLogout: Bool) {
        if isFromLogout {
            cachedViewController.removeAll()
        }
        displayContentViewController(CHILD_LOGIN_KEY)
    }
    
    public func showHomeScreen() {
        displayContentViewController(CHILD_HOME_KEY)
    }
    
    public func displayContentViewController(_ identifier: String, secondaryIdentifier: String? = nil) {
        if activeViewControllerId != identifier {
            // Screen Initialization
            var vc: UIViewController?
            if let cachedVC = cachedViewController[identifier] {
                vc = cachedVC
            }
            else if identifier == CHILD_LOGIN_KEY {
                if authStoryboard == nil {
                    authStoryboard = UIStoryboard.init(name: "Auth", bundle: nil)
                }
                vc = authStoryboard?.instantiateInitialViewController()
            }
            else if let vendorTabVC = storyboard?.instantiateViewController(withIdentifier: identifier) {
                cachedViewController[identifier] = vendorTabVC
                vc = vendorTabVC
            }
            
            // Screen Implementation
            activeViewControllerId = identifier
            addChild(vc!)
            
            let existingView = view.viewWithTag(CHILD_KEY)
            if existingView != nil {
                vc?.view.alpha = 0
            }
            
            vc!.view.frame = view.bounds
            view.addSubview(vc!.view)
            
            if existingView != nil {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    existingView?.alpha = 0
                }, completion: { finished in
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        vc?.view.alpha = 1
                    }, completion: { finished in
                        if finished {
                            existingView?.removeFromSuperview()
                            let firstVC = self.children.first
                            firstVC?.removeFromParent()
                            firstVC?.didMove(toParent: nil)
                        }
                    })
                })
            }
            
            vc!.view.tag = CHILD_KEY
            vc!.view.setNeedsLayout()
            vc!.view.layoutIfNeeded()
            
            vc!.didMove(toParent: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public extension UIViewController {
    public var managerViewController: ManagerViewController? {
        return managerViewControllerForViewController(self)
    }
    
    private func managerViewControllerForViewController(_ controller: UIViewController) -> ManagerViewController? {
        if let managerController = controller as? ManagerViewController {
            return managerController
        }
        
        if let parent = controller.parent {
            return managerViewControllerForViewController(parent)
        }
        else if let parent = controller.presentingViewController {
            return managerViewControllerForViewController(parent)
        }
        else {
            return nil
        }
    }
}
