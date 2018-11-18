//
//  RegisterViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Register"
        Notify.shared.listen(
            self,
            selector: #selector(responseDidReceived(_:)),
            name: NotifName.authRegister,
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        registerButton.layer.cornerRadius = 5
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
                title: "Failed to Register",
                message: "",
                sender: self)
        }
    }
    
    private func validateForm() -> Bool {
        var message = ""
        
        if nameField.text!.isEmpty || usernameField.text!.isEmpty ||
            emailField.text!.isEmpty || passwordField.text!.isEmpty {
            message = "Field cannot be empty"
        }
        
        if !emailField.text!.isValidEmail() {
            message = "Email is invalid"
        }
        
        if message == "" {
            return true
        }
        else {
            Alertify.displayAlert(title: "Error Register", message: message, sender: self)
            return false
        }
    }

    // MARK: - Action
    @IBAction func authRegister(_ sender: Any) {
        if validateForm() {
            let params = [
                "name": nameField.text!,
                "email": emailField.text!,
                "username": usernameField.text!,
                "password": passwordField.text!
            ]
            SVProgressHUD.show()
            Apify.shared.register(parameters: params)
        }
    }
}
