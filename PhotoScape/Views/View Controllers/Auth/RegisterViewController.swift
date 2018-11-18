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

    // MARK: - Outlet
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subviewSettings()
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
    
    private func subviewSettings() {
        navigationItem.title = Localify.get("register.title")
        nameField.placeholder = Localify.get("register.placeholder.fullname")
        usernameField.placeholder = Localify.get("register.placeholder.username")
        emailField.placeholder = Localify.get("register.placeholder.email")
        passwordField.placeholder = Localify.get("register.placeholder.password")
        registerButton.setTitle(Localify.get("register.button.register"), for: .normal)
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
                title: Localify.get("register.alert.register_failed.title"),
                message: Localify.get("register.alert.register_failed.message"),
                sender: self)
        }
    }
    
    private func validateForm() -> Bool {
        var error = [String]()
        
        if nameField.text!.isEmpty {
            error.append(Localify.get("register.alert.form_invalid.message.fullname_empty"))
        }
        
        if usernameField.text!.isEmpty {
            error.append(Localify.get("register.alert.form_invalid.message.username_empty"))
        }
        
        if emailField.text!.isEmpty {
            error.append(Localify.get("register.alert.form_invalid.message.email_empty"))
        }
        else if !emailField.text!.isValidEmail() {
            error.append(Localify.get("register.alert.form_invalid.message.email_invalid"))
        }
        
        if passwordField.text!.isEmpty {
            error.append(Localify.get("register.alert.form_invalid.message.password_empty"))
        }
        else if passwordField.text!.count <= 6 {
            error.append(Localify.get("register.alert.form_invalid.message.password_length"))
        }
        
        if error.isEmpty {
            return true
        }
        else {
            let message: String = error.joined(separator: "\n")
            Alertify.displayAlert(title: Localify.get("register.alert.form_invalid.title"), message: message, sender: self)
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
