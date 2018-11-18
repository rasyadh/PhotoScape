//
//  AlbumsCollectionViewController.swift
//  PhotoScape
//
//  Created by Twiscode on 13/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class PlaylistViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() {
        navigationItem.title = "Playlist"
        collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "albumCell")
        collectionView.register(UINib(nibName: "AlbumSectionCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "albumSectionCell")
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "artistCollectionCell")
        SVProgressHUD.show()
    }
    
    func initData() {
        Apify.shared.fetchPlaylist()
        SVProgressHUD.dismiss()
        collectionView.reloadData()
    }
}

// MARK: - DataSource
extension PlaylistViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return Storify.shared.albums?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumSectionCell", for: indexPath) as! AlbumSectionCollectionReusableView
            if indexPath.section == 0 {
                section.albumSectionLabel.text = "Artist"
            }
            else {
                section.albumSectionLabel.text = "Albums"
            }
            return section
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCollectionCell", for: indexPath) as! ArtistCollectionViewCell
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCollectionViewCell
            
            if let album = Storify.shared.albums?[indexPath.row] {
                cell.imageView.sd_setImage(with: URL(string: album.image), completed: nil)
                cell.nameLabel.text = album.name
                cell.detailLabel.text = album.detail
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - Delegate
extension PlaylistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = Storify.shared.albums?[indexPath.item] {
            Alertify.displayAlert(title: album.name, message: album.detail, sender: self)
        }
    }
}

// MARK: - DelegateFlowLayout
extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.size.width, height: 120)
        case 1:
            return CGSize(width: (collectionView.bounds.size.width / 2) - 24, height: 200)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 16, bottom: 8, right: 16)
    }
}
