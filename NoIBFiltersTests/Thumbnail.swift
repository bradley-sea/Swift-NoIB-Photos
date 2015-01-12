//
//  Thumbnail.swift
//  NoIBFilters
//
//  Created by Bradley Johnson on 12/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Thumbnail {
    
    var originalImage : UIImage?
    var filteredImage : UIImage?
    var filterName : String
    var imageQueue : NSOperationQueue
    var gpuContext : CIContext
    var imageFilter : CIFilter?
    
    
    init( filterName : String, operationQueue : NSOperationQueue, context : CIContext) {
        self.filterName = filterName
        self.imageQueue = operationQueue
        self.gpuContext = context
    }
    
    func generateFilteredImage (completionHandler: () -> (Void)) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            var startImage = CIImage(image: self.originalImage)
            self.imageFilter = CIFilter(name: self.filterName)
            self.imageFilter?.setDefaults()
            self.imageFilter?.setValue(startImage, forKey: kCIInputImageKey)
            
            var result = self.imageFilter?.valueForKey(kCIOutputImageKey) as CIImage
            var extent = result.extent()
            var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
            self.filteredImage = UIImage(CGImage: imageRef)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler()
            })
        }

        
    }
}