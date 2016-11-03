//
//  StringExtension.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 10/26/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import Foundation

extension String {
    func image() -> UIImage {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.whiteColor().set()
        let rect = CGRect(origin: CGPointZero, size: size)
        UIRectFill(CGRect(origin: CGPointZero, size: size))
        (self as NSString).drawInRect(rect, withAttributes: [NSFontAttributeName: UIFont.systemFontOfSize(30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var attributedStringFromHtml: NSAttributedString? {
        do {
            return try NSAttributedString(data: self.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        } catch _ {
            print("Cannot create attributed String")
        }
        return nil
    }
    
}