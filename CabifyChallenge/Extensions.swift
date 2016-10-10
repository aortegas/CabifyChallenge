//
//  Extensions.swift
//  CabifyChallenge
//
//  Created by Alberto on 10/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
}
