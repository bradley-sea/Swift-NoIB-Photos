//
//  HomeViewController.swift
//  NoIBFilters
//
//  Created by Bradley Johnson on 12/5/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import Social

public class HomeViewController: UIViewController,UIPopoverPresentationControllerDelegate,PhotoSelected, UICollectionViewDataSource {
    
    var mainDisplayImageView : UIImageView!
    var alertController : UIAlertController!
    var photoButton : UIButton!
    var filterCollectionView : UICollectionView!
    var constraintForFilterCollectionViewBottom : NSLayoutConstraint!
    var constraintsForMainDisplay = [NSLayoutConstraint]()
    var filteredThumbnails = [Thumbnail]()
    var selectedImageThumbnail : UIImage?
    var gpuContext : CIContext!
    let imageQueue = NSOperationQueue()
    
    override public func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.whiteColor()
        self.mainDisplayImageView = UIImageView()
        self.mainDisplayImageView.backgroundColor = UIColor.redColor()
        self.mainDisplayImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        rootView.addSubview(mainDisplayImageView)
        self.photoButton = UIButton()
        self.photoButton.addTarget(self, action: "presentAlertController", forControlEvents: UIControlEvents.TouchUpInside)
        self.photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        rootView.addSubview(photoButton)
        photoButton.setTitle("Image", forState: .Normal)
        photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.filterCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.filterCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let flowLayout = self.filterCollectionView.collectionViewLayout as UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        rootView.addSubview(self.filterCollectionView)
        let views : NSDictionary = ["MDImageView" : self.mainDisplayImageView, "photoButton" : photoButton, "filterCollectionView" : self.filterCollectionView];
        
        self.view = rootView
        self.setupConstraintsForViews(views)
        
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.gpuContext = CIContext(EAGLContext: myEAGLContext, options: options)
        self.setupFilters()
          println(self.topLayoutGuide.length)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
          println(self.topLayoutGuide.length)
        let shareButton = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.Plain, target: self, action: "sharePressed");
        self.navigationItem.rightBarButtonItem = shareButton
        self.setupAlertController()
        self.filterCollectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        self.filterCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func sharePressed() {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let mySLComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            mySLComposerSheet.addImage(self.mainDisplayImageView.image)
            mySLComposerSheet.completionHandler = {(result : SLComposeViewControllerResult) -> () in
            println(result)
            }
            self.presentViewController(mySLComposerSheet, animated: true, completion: nil)
        }
        
    }
    
    func setupFilters() {
        var filterNames = ["CISepiaTone","CIPhotoEffectChrome","CIPhotoEffectInstant","CIPhotoEffectMono","CIPhotoEffectNoir","CIPhotoEffectTonal","CIPhotoEffectTransfer"]
        for name in filterNames {
            let thumbnail = Thumbnail(filterName: name, operationQueue: self.imageQueue, context: self.gpuContext)
            self.filteredThumbnails.append(thumbnail)
        }
    }
    
    func presentAlertController() {
        if self.alertController.popoverPresentationController != nil {
            self.alertController.popoverPresentationController?.delegate = self
        }
        self.presentViewController(self.alertController, animated: true, completion: nil)
        
    }
    
    func setupAlertController() {
        self.alertController = UIAlertController(title:nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        let galeryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            let galleryViewController = GalleryViewController()
            galleryViewController.delegate = self
            self.presentViewController(galleryViewController, animated: true, completion: nil)
        }
        let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
          self.constraintForFilterCollectionViewBottom.constant = 8
            
            for constraint in self.constraintsForMainDisplay {
                constraint.constant = constraint.constant + 45
                println(constraint.constant)
            }
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        self.alertController.addAction(cameraAction)
        self.alertController.addAction(galeryAction)
        self.alertController.addAction(filterAction)
        self.alertController.addAction(cancelAction)

        if self.alertController.popoverPresentationController != nil {
            println("popover!")
            self.alertController.modalPresentationStyle = UIModalPresentationStyle.Popover  
            self.alertController.popoverPresentationController?.delegate = self
        }
    }
    
    public func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.photoButton
        popoverPresentationController.sourceRect = self.photoButton.bounds
    }

    func setupConstraintsForViews(views : NSDictionary) {
        let photoButtonCenterX = NSLayoutConstraint(item: views["photoButton"]!,
            attribute: .CenterX,
            relatedBy:.Equal,
            toItem: self.view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0)
        self.view.addConstraint(photoButtonCenterX)
        let photoButtonYConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[photoButton]-|",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(photoButtonYConstraint)
        let mainDisplayImageViewXConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[MDImageView]-|",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(mainDisplayImageViewXConstraints)
        for constraint in mainDisplayImageViewXConstraints as [NSLayoutConstraint] {
            self.constraintsForMainDisplay.append(constraint)
        }
        let mainDisplayImageViewYConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-72-[MDImageView]-35-[photoButton]",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(mainDisplayImageViewYConstraint)
        
        for constraint in mainDisplayImageViewYConstraint as [NSLayoutConstraint] {
            self.constraintsForMainDisplay.append(constraint)
        }
        
        let filterCollectionViewXConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[filterCollectionView]|",
            options: nil,
            metrics: nil,
            views: views)
        self.view.addConstraints(filterCollectionViewXConstraint)
        
        let filterCollectionViewHeightConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[filterCollectionView(100)]",
            options: nil,
            metrics: nil,
            views: views)
        self.filterCollectionView.addConstraints(filterCollectionViewHeightConstraint)
        
        let filterCollectionViewYConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[filterCollectionView]-(-120)-|", options: nil, metrics: nil, views: views)
        self.constraintForFilterCollectionViewBottom = filterCollectionViewYConstraint.last as NSLayoutConstraint
        self.view.addConstraints(filterCollectionViewYConstraint)
        
    }
    //MARK: PhotoSelectedDelegate
    func userDidSelectPhoto(photo: UIImage) {
        println(self.topLayoutGuide.length)
        self.mainDisplayImageView.image = photo
        self.generateThumbnail()
        for filter in self.filteredThumbnails {
            filter.originalImage = self.selectedImageThumbnail
        }
        self.filterCollectionView.reloadData()
    }
    
    func generateThumbnail () {
        var size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.mainDisplayImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.selectedImageThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //MARK: UICollectionViewDataSource
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mainDisplayImageView.image != nil {
        return self.filteredThumbnails.count
        } else {
            return 0
        }
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filterCell", forIndexPath: indexPath) as GalleryCollectionViewCell
        let filteredThumbnail = self.filteredThumbnails[indexPath.row]
        if filteredThumbnail.filteredImage == nil {
            cell.imageView.image = self.selectedImageThumbnail
            filteredThumbnail.generateFilteredImage({ () -> (Void) in
                self.filterCollectionView.reloadItemsAtIndexPaths([indexPath])
            })
        } else {
            cell.imageView.image = filteredThumbnail.filteredImage
        }
        return cell
    }
}
