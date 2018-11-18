//
//  ViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class PhotoListViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [Photo]? = [Photo]()
    
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
        navigationItem.title = "Popular Photos"
        tableView.estimatedRowHeight = 152
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCell")
        SVProgressHUD.show()
    }
    
    func initData() {
        Apify.shared.fetchPhotos(completion: { [self] photos in
            if let photos = photos {
                self.photos = photos
            }
            SVProgressHUD.dismiss()
            self.tableView.alpha = 1.0
            self.tableView.reloadData()
        })
    }
}

// MARK: - DataSource
extension PhotoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        if let photo = self.photos?[indexPath.row] {
            cell.nameLabel.text = photo.name
            cell.nameLabel.sizeToFit()
            cell.ratingLabel.text = "Rating: \(photo.rating)"
            cell.ratingLabel.sizeToFit()
            cell.mainImageView.sd_setImage(with: URL(string: photo.image_url), completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152.0
    }
}

// MARK: - Delegate
extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPhotoDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Navigation
extension PhotoListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? PhotoDetailViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let photo = self.photos?[indexPath.row]
            vc?.imageUrl = photo?.image_url
        }
    }
}
