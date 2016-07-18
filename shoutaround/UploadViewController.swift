//
//  UploadViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/18/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//


class UploadViewController: UIViewController {

    @IBOutlet weak var uploadImage: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        
        uploadImage.image = imageSelected
        
    }
    
    

    
    
}
