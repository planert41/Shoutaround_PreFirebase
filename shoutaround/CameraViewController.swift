//
//  CameraViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/17/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import Fusuma

class CameraViewController: UIViewController, FusumaDelegate {
    
    
    override func viewDidAppear(animated: Bool) {
        
        let fusuma = Fusuma()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
        
    }

    
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
}
