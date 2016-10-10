//
//  Appearance.swift
//  CabifyChallenge
//
//  Created by Alberto on 10/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit

class Appearance: UIView {

    internal static func setupCollection (collection: UICollectionViewCell) {
        
        collection.contentView.layer.borderWidth = 1.0
        collection.contentView.layer.borderColor = UIColor.clearColor().CGColor
        collection.contentView.layer.masksToBounds = true
        collection.layer.shadowColor = UIColor.grayColor().CGColor
        collection.layer.shadowOffset = CGSizeMake(0, 1.0)
        collection.layer.shadowRadius = 1.0
        collection.layer.shadowOpacity = 1.0
        collection.layer.masksToBounds = false
        collection.layer.shadowPath = UIBezierPath(roundedRect: collection.bounds, cornerRadius: collection.contentView.layer.cornerRadius).CGPath
    }
}
