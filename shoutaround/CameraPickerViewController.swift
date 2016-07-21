//
//  CameraPickerViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/20/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//


import Parse
import ParseUI
import AssetsLibrary


class CameraPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()
    
    
    override func viewDidAppear(animated: Bool) {
        print(showCamera)
        
        if showCamera == 1 {
            showImagePicker()
        } else {
            showCamera = 0
        }
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
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UploadViewController")
        self.presentViewController(viewController, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        showCamera = 0
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.tabBarController?.selectedIndex = 4
        
        }

    }

