//
//  NetworkManager.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/20/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import AssetsLibrary

public class NetworkManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    public class var sharedInstance: NetworkManager
    {
        struct Singleton
        {
            static let instance = NetworkManager()
        }
        
        return Singleton.instance
}
    
    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()

    
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
        self.dismissViewControllerAnimated(false, completion: nil)
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UploadViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
        print("finished")
    }
    


}