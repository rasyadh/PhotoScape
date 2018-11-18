//
//  PostsViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 12/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    var refreshser: UIRefreshControl!
    
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
        navigationItem.title = "Posts"
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        
        refreshser = UIRefreshControl()
        tableView.addSubview(refreshser)
        refreshser.addTarget(self, action: #selector(reloadPostData), for: .valueChanged)
        
        SVProgressHUD.show()
    }
    
    func initData() {
        Apify.shared.fetchPosts()
        Notify.shared.listen(
            self,
            selector: #selector(responseDidReceived(_:)),
            name: NotifName.fetchPosts,
            object: nil)
    }
    
    @objc func responseDidReceived(_ notification: Notification) {
        SVProgressHUD.dismiss()
        tableView.alpha = 1.0
        self.tableView.reloadData()
    }
    
    @objc func reloadPostData() {
        Storify.shared.posts?.append(Post(id: 10000, title: "Test add data", body: "This is test data"))
        tableView.reloadData()
        refreshser.endRefreshing()
    }
}

// MARK: - DataSource
extension PostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storify.shared.posts?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        if let post = Storify.shared.posts?[indexPath.row] {
            cell.titleLabel.text = post.title
            cell.bodyLabel.text = post.body
        }
        
        return cell
    }
}

// MARK: - Delegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
