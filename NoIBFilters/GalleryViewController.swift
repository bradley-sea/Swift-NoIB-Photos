//
//  GalleryViewController.swift
//  NoIBFilters
//
//  Created by Bradley Johnson on 12/5/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
   weak var delegate : PhotoSelected?
    var galleryCollectionView : UICollectionView!
    var galleryPhotos = [UIImage]()
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        self.galleryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        rootView.addSubview(galleryCollectionView)
        self.galleryCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["galleryCollection" : self.galleryCollectionView]
        self.view = rootView
        self.setupConstraintsForViews(views)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.galleryPhotos = [UIImage(named: "1.jpg")!,UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!]
        self.galleryCollectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.galleryCollectionView.dataSource = self
        self.galleryCollectionView.delegate = self
        if let flowLayout = self.galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.view.frame.size.width * 0.6, height: self.view.frame.size.width * 0.6)
        }
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryPhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as GalleryCollectionViewCell
        cell.imageView.image = self.galleryPhotos[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.userDidSelectPhoto(self.galleryPhotos[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setupConstraintsForViews(views : NSDictionary) {
        let galleryCollectionViewXConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[galleryCollection]|",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(galleryCollectionViewXConstraints)
        let galleryCollectionViewYConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[galleryCollection]|",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(galleryCollectionViewYConstraints)
    }
}

protocol PhotoSelected : class {
    func userDidSelectPhoto(photo : UIImage) -> Void
}
