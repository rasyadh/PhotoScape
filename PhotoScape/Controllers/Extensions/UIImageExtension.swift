//
//  UIImageExtension.swift
//  CBN
//
//  Created by Aditya Nanda Purnama on 19/10/18.
//  Copyright © 2018 CBN. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
