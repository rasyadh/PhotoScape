//
//  UsersViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SVProgressHUD

class UsersViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() {
        navigationItem.title = "Users"
        tableView.estimatedRowHeight = 88
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        SVProgressHUD.show()
    }
    
    func initData() {
        Apify.shared.fetchUsers()
        Notify.shared.listen(
            self,
            selector: #selector(responseDidReceived(_:)),
            name: NotifName.fetchUsers,
            object: nil)
    }
    
    @objc func responseDidReceived(_ notification: Notification) {
        SVProgressHUD.dismiss()
        tableView.alpha = 1.0
        self.tableView.reloadData()
    }
}

// MARK: - DataSource
extension UsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storify.shared.users?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        if let user = Storify.shared.users?[indexPath.row] {
            cell.nameLabel.text? = user.name
            cell.emailLabel.text? = user.email
            cell.phoneLabel.text? = user.phone
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
}

// MARK: - Delegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
