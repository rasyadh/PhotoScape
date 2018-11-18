//
//  ArtistViewCell.swift
//  PhotoScape
//
//  Created by Twiscode on 14/11/18.
//  Copyright © 2018 Twiscode. All rights reserved.
//

import UIKit

class ArtistViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setCircularImageView(10.0)
    }
    
    func setCircularImageView(_ radius: CGFloat) {
        self.imageView.layer.cornerRadius = CGFloat(roundf(
            Float(self.imageView.frame.size.width / 2.0)
        ))
    }
}
