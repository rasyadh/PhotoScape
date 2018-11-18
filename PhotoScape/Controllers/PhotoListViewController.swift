//
//  ViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 07/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

class PhotoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var photos: [Photo]? = [Photo]()
    var selectedIndexPath: IndexPath?
    
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
        self.title = "Popular"
        tableView.estimatedRowHeight = 152
    }
    
    func initData() {
        Apify.shared.fetchPhotos(completion: { [self] photos in
            if let photos = photos {
                self.photos = photos
            }
            self.tableView.reloadData()
        })
    }
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoListTableViewCell
        
        if let photo = self.photos?[indexPath.row] {
            cell.mainImageView.hideSkeleton()
            cell.nameLabel.hideSkeleton()
            cell.ratingLabel.hideSkeleton()
            
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndexPath = indexPath
        return indexPath
    }
}

extension PhotoListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController,
            let indexPath = self.selectedIndexPath {
            let photo = self.photos?[indexPath.row]
            vc.imageUrl = photo?.image_url
        }
    }
}

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.showAnimatedSkeleton()
        nameLabel.showAnimatedSkeleton()
        ratingLabel.showAnimatedSkeleton()
    }
}
