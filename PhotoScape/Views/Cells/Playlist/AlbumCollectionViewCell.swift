//
//  AlbumCollectionViewCell.swift
//  PhotoScape
//
//  Created by Twiscode on 14/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setCircularImageView(10.0)
    }
    
    func setCircularImageView(_ radius: CGFloat) {
        self.imageView.layer.cornerRadius = radius
    }
}
