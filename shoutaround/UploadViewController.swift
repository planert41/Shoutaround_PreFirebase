//
//  UploadViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/18/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//


class UploadViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!

    
    override func viewDidAppear(animated: Bool) {
        
        uploadImage.image = imageSelected
        
        postCaption.delegate = self
        postCaption.text = "Caption Here"
        postCaption.textColor = UIColor.lightGrayColor()
        
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
    
    @IBAction func UploadBack(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    
    
}
