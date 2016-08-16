//
//  RatingsViewCell.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 8/13/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import Foundation

class RatingsViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var RatingButton: UIButton!
  //  @IBOutlet weak var RatingView: UIView!
    
    var cellViewController:UploadViewController?
    
    override func prepareForReuse() {

    }
    
    override func awakeFromNib() {
    }
    
    @IBAction func EmoticonSelected(sender: AnyObject) {
        
        // If not selected
        
        if self.cellViewController!.postCaption.text == "Caption Here" {
            self.cellViewController!.postCaption.text = ""
        }
        
        var tempCaption = self.cellViewController!.postCaption.text
        
        if tempCaption?.characters.last == " " {
            tempCaption = String(tempCaption!.characters.dropLast())
        }
        
        if tags.contains((RatingButton.titleLabel?.text)!)
        {
            tags.removeAtIndex(tags.indexOf((RatingButton.titleLabel?.text)!)!)
            tempCaption = tempCaption!.stringByReplacingOccurrencesOfString(" #" + EmoticonDictionary[(RatingButton.titleLabel?.text)!]!, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
        }else {
            
            tags.append((RatingButton.titleLabel?.text)!)
            tempCaption = tempCaption! + " #" + EmoticonDictionary[(RatingButton.titleLabel?.text)!]!
            
        }
        
        self.cellViewController!.postCaption.text = tempCaption
        self.cellViewController?.displayedtags = tags
        
        
        /*
         var currentpath = (cellCollectionView!.indexPathForCell(self.testcellCollectionView!))
         var indexPath = NSIndexPath(forItem: 0, inSection: 0)
         print(currentpath)
         cellCollectionView.de
         cellCollectionView!.deleteItemsAtIndexPaths(currentpath?.row)
         cellCollectionView!.
         cellCollectionView!.moveItemAtIndexPath(currentpath!, toIndexPath: indexPath.row)
         */
        /*
         if self.select == Selection.no {
         
         // Change to Selected
         // self.select = Selection.yes
         self.EmoticonView.transform = CGAffineTransformMakeScale(0.8, 0.8)
         
         UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
         self.EmoticonView.transform = CGAffineTransformIdentity
         }, completion: nil)
         tags = tags + (EmoticonButton.titleLabel?.text)!
         
         } else {
         // self.select = Selection.no
         tags = tags.stringByReplacingOccurrencesOfString((EmoticonButton?.titleLabel?.text)!, withString: "")
         
         }
         
         print(tags)
         print(self.EmoticonButton.titleLabel)
         self.cellViewController!.updateTags()
         */
        
    }

    

}