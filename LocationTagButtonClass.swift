//
//  LocationTagButtonClass.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 8/13/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.blueColor().CGColor
            
            
            
        }        
    }
    
