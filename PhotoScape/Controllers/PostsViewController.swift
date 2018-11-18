//
//  PostsViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 12/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SkeletonView

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func initView() {
        title = "Posts"
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.reloadData()
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storify.shared.posts?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        if let post = Storify.shared.posts?[indexPath.row] {
            cell.titleLabel.hideSkeleton()
            cell.bodyLabel.hideSkeleton()
            
            cell.titleLabel.text = post.title
            cell.bodyLabel.text = post.body
        }
        
        return cell
    }
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.showAnimatedGradientSkeleton()
        bodyLabel.showAnimatedGradientSkeleton()
    }
}
