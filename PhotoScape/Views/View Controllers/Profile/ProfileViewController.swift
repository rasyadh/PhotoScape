//
//  ProfileViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 09/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selectField: UITextField!
    
    private let myPickerData = [String](arrayLiteral: "Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pref = UserDefaults.standard
        let userData = pref.dictionary(forKey: Preferences.userData)
        if let user = userData?["email"] as? String {
            let user = user.split(separator: "@")[0]
            navigationItem.title = String(user)
        }
        else {
            navigationItem.title = "Profile"
        }
        
        let picker = UIPickerView()
        selectField.inputView = picker
        picker.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        logoutButton.layer.cornerRadius = 5
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

// MARK: - DataSource
extension ProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
}

// MARK: - Delegate
extension ProfileViewController: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectField.text = myPickerData[row]
    }
}
