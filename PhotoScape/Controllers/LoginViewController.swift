//
//  LoginViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Login"
        
        Notify.shared.listen(
            self,
            selector: #selector(responseDidReceived(_:)),
            name: NotifName.authLogin,
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        loginButton.layer.cornerRadius = 5
    }
    
    @objc func responseDidReceived(_ notification: Notification) {
        let success = notification.userInfo!["success"] as! Bool
        
        if success {
            SVProgressHUD.showSuccess(withStatus: "Success")
            SVProgressHUD.dismiss(withDelay: 0.5) {
                self.managerViewController?.showHomeScreen()
            }
        }
        else {
            SVProgressHUD.dismiss()
            Alertify.displayAlert(
                title: "Failed to login",
                message: "Email or password wrong",
                sender: self)
        }
    }
    
    private func validateForm() -> Bool {
        var message = ""
        
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            message = "Field cannot be empty"
        }
        
        if !emailField.text!.isValidEmail() {
            message = "Email is invalid"
        }
        
        if message == "" {
            return true
        }
        else {
            Alertify.displayAlert(title: "Error Login", message: message, sender: self)
            return false
        }
    }

    // MARK: Action
    @IBAction func authLogin(_ sender: Any) {
        if validateForm() {
            let params = [
                "email": emailField.text!,
                "password": passwordField.text!
            ]
            SVProgressHUD.show()
            Apify.shared.login(parameters: params)
        }
    }
    
    @IBAction func toRegister(_ sender: Any) {
        performSegue(withIdentifier: "showRegister", sender: nil)
        emailField.text! = ""
        passwordField.text! = ""
    }
}
