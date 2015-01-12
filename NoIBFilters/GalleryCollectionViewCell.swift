//
//  GalleryCollectionViewCell.swift
//  NoIBFilters
//
//  Created by Bradley Johnson on 12/5/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["imageView" : self.imageView]
        self.contentView.addSubview(self.imageView)
        let imageViewContraintsX = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[imageView]|",
            options: nil,
            metrics: nil,
            views: views)
        self.contentView.addConstraints(imageViewContraintsX)
        let imageViewContraintsY = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[imageView]|",
            options: nil,
            metrics: nil,
            views: views)
        self.contentView.addConstraints(imageViewContraintsY)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
