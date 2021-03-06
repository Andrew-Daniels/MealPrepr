//
//  RoundedUIView.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIView: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var clips: Bool = false {
        didSet {
            self.clipsToBounds = clips
        }
    }
    
    public var effect: UIBlurEffect.Style! {
        didSet {
            if (self.effectView != nil) {
                self.effectView.removeFromSuperview()
            }
            self.backgroundColor = .clear
            let e = UIBlurEffect(style: self.effect)
        
            self.effectView = UIVisualEffectView(effect: e)
            self.effectView.frame = self.bounds
            self.effectView.layer.cornerRadius = self.cornerRadius
            self.insertSubview(self.effectView, at: 0)
            self.effectView.clipsToBounds = true
        }
    }
    
    public var hasEffectView: Bool = true {
        didSet {
            if !hasEffectView && self.effectView != nil {
                self.effectView.removeFromSuperview()
            }
        }
    }
    
    private var effectView: UIVisualEffectView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.effectView == nil && hasEffectView) {
            self.effect = .dark
        }
        if self.effectView != nil {
            self.effectView.frame = self.bounds
        }
    }
}

