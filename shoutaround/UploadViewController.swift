//
//  UploadViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/18/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import UIKit
import AssetsLibrary


public var SelectedImageGPS: CLLocation?
public var SelectedImageData: UIImage?

class UploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LocationIcon: UIImageView!
    @IBOutlet weak var locationView: UIView!

    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()
    
    
    override func viewDidLoad() {

    }
    
    
    override func viewWillAppear(animated: Bool) {
        if SelectedImageData == nil {
            showImagePicker()
        }
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    
    @IBAction func UploadBack(sender: AnyObject) {
        
        showImagePicker()
        
    }
    
    func showImagePicker() {
        
        var image = UIImagePickerController()
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.delegate = self
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        SelectedImageData = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        
        library.assetForURL(url, resultBlock: {
            (asset: ALAsset!) in
            
            if asset.valueForProperty(ALAssetPropertyLocation) != nil {
                
                SelectedImageGPS = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                
            }
            }, failureBlock: {
                (error: NSError!) in
                NSLog("Error!")
            }
        )
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        SelectedImageData = nil
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.selectedIndex = LastTab

        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        uploadImage.image = SelectedImageData
        
        postCaption.delegate = self
        postCaption.text = "Caption Here"
        postCaption.textColor = UIColor.lightGrayColor()
        
        LocationIcon.image = UIImage(named: "caps_lock_on_filled")
        
        
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor

        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    


    
}
