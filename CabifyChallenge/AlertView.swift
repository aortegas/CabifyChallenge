//
//  AlertView.swift
//  CabifyChallenge
//
//  Created by Alberto on 7/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit

class AlertView: UIView {

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var view: UIView!

    
    // MARK: - Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
        setupView()
    }

    
    // MARK: - View Methods
    func loadViewFromXibFile() -> UIView {

        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AlertView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    func setupView() {
        
        view = loadViewFromXibFile()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        self.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.0
        visualEffectView.layer.cornerRadius = 12.0
    }

    func displayView(onView: UIView, withTitle: String) {

        self.alpha = 0.0
        titleLabel.text = withTitle
        onView.addSubview(self)

        // Constraints for view.
        addPositionView(onView)
        onView.needsUpdateConstraints()

        // Show view.
        transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 1.0
                self.transform = CGAffineTransformIdentity
        })
    }
    
    func hideView() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }

    private func addPositionView(onView: UIView) {
        
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal,
            toItem: onView, attribute: .CenterY, multiplier: 1.0, constant: -25.0))
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal,
            toItem: onView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
    }

    override func updateConstraints() {
        
        super.updateConstraints()
        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.window!.frame.height))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.window!.frame.width))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal,
            toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal,
            toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal,
            toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal,
            toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    }
}
