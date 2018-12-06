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
    
    public var effect: UIBlurEffectStyle = .dark {
        didSet {
            self.backgroundColor = .clear
            let e = UIBlurEffect(style: self.effect)
        
            let v = UIVisualEffectView(effect: e)
            v.frame = self.bounds
            v.layer.cornerRadius = self.cornerRadius
            self.insertSubview(v, at: 0)
            v.clipsToBounds = true
        }
    }
}

