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

    // MARK: - Outlet
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subviewSettings()
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
    
    private func subviewSettings() {
        navigationItem.title = Localify.get("login.title")
        emailField.placeholder = Localify.get("login.placeholder.email")
        passwordField.placeholder = Localify.get("login.placeholder.password")
        loginButton.setTitle(Localify.get("login.button.login"), for: .normal)
        registerButton.setTitle(Localify.get("login.button.register"), for: .normal)
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
                title: Localify.get("login.alert.login_failed.title"),
                message: Localify.get("login.alert.login_failed.message"),
                sender: self)
        }
    }
    
    private func validateForm() -> Bool {
        var error = [String]()
        
        if emailField.text!.isEmpty {
            error.append(Localify.get("login.alert.form_invalid.message.email_empty"))
        }
        else if !emailField.text!.isValidEmail() {
            error.append(Localify.get("login.alert.form_invalid.message.email_invalid"))
        }
        
        if passwordField.text!.isEmpty {
            error.append(Localify.get("login.alert.form_invalid.message.password_empty"))
        }
        
        if error.isEmpty {
            return true
        }
        else {
            let message: String = error.joined(separator: "\n")
            Alertify.displayAlert(title: Localify.get("login.alert.form_invalid.title"), message: message, sender: self)
            return false
        }
    }

    // MARK: - Action
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
