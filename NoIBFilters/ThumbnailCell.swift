//
//  ThumbnailCell.swift
//  NoIBFilters
//
//  Created by Bradley Johnson on 12/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    var imageView : UIImageView
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.imageView.backgroundColor = UIColor.blueColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
