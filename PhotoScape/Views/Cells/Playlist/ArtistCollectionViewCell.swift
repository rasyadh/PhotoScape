//
//  ArtistCollectionViewCell.swift
//  PhotoScape
//
//  Created by Twiscode on 14/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ArtistViewCell", bundle: nil), forCellWithReuseIdentifier: "artistCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - DataSource
extension ArtistCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistViewCell
        
        if let artist = Storify.shared.artists?[indexPath.row] {
            cell.imageView.sd_setImage(with: URL(string: artist.image), completed: nil)
            cell.nameLabel.text = artist.name
        }
        
        return cell
    }
}

// MARK: - Delegate
extension ArtistCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let artist = Storify.shared.artists?[indexPath.item] {
            if let sender = self.window?.rootViewController {
                Alertify.displayAlert(title: "Artist", message: artist.name, sender: sender)
            }
        }
    }
}

// MARK: - DelegateFlowLayout
extension ArtistCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 4, height: collectionView.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
    }
}
