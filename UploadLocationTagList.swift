//
//  Listflow.swift
//  collectiontest
//
//  Created by Wei Zou Ang on 7/11/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import UIKit

class UploadLocationTagList: UICollectionViewFlowLayout {
    
    // let itemHeight: CGFloat = 50
    
    override init() {
        super.init()
        setupLayout()
        
    }
    
    /**
     Init method
     
     - parameter aDecoder: aDecoder
     
     - returns: self
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /**
     Sets up the layout for the collectionView. 0 distance between each cell, and vertical layout
     */
    func setupLayout() {
        
        estimatedItemSize = CGSize(width: 200, height: 40)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .Horizontal
        
        
    }
    
    func itemWidth() -> CGFloat {
        return CGRectGetWidth(collectionView!.frame)
    }
    
    /*
     override var itemSize: CGSize {
     set {
     self.itemSize = CGSizeMake(itemWidth(), itemWidth() + 100)
     }
     get {
     return CGSizeMake(itemWidth(), itemWidth() + 100)
     }
     }
     */
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}