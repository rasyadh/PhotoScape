//
//  UsersViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SkeletonView

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() {
        self.title = "Users"
        tableView.estimatedRowHeight = 88
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
        self.tableView.reloadData()
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storify.shared.users?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        if let user = Storify.shared.users?[indexPath.row] {
            cell.userLabel.hideSkeleton()
            cell.emailLabel.hideSkeleton()
            cell.phoneLabel.hideSkeleton()
            
            cell.userLabel.text = user.name
            cell.emailLabel.text = user.email
            cell.phoneLabel.text = user.phone
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userLabel.showAnimatedSkeleton()
        emailLabel.showAnimatedSkeleton()
        phoneLabel.showAnimatedSkeleton()
    }
}
