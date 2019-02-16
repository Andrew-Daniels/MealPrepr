//
//  MPLikeControl.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/15/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class MPLikeControl: UIControl {
    
    private var likeBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 0
        return btn
    }()
    
    private var dislikeBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "Dislike")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 1
        return btn
    }()
    
    private var view: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    private var selectedBtn: UIButton?
    var rating = Review.Rating.NotRated
    var delegate: MPLikeControlDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initMPLikeControl()
    }
    
    func hasRating() -> Bool {
        return selectedBtn != nil
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        switch (sender.tag) {
        case 0:
            //Like clicked
            setButtonSelected(button: likeBtn, selected: true)
            setButtonSelected(button: dislikeBtn, selected: false)
            rating = .Like
            break
        case 1:
            //Dislike clicked
            setButtonSelected(button: likeBtn, selected: false)
            setButtonSelected(button: dislikeBtn, selected: true)
            rating = .Dislike
            break
        default:
            return
        }

    }
    
    private func initMPLikeControl() {
        
        self.backgroundColor = .clear
        
        dislikeBtn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        setupConstraints()
        
    }
    
    private func setButtonSelected(button: UIButton, selected: Bool) {
        
        if button != selectedBtn {
            //Let delegate know that the rating changed
            delegate?.selectedChanged(sender: self)
        }
        
        if selected {
            button.tintColor = redColor
        } else {
            button.tintColor = .white
        }
        
        selectedBtn = button
    }

    private func setupConstraints() {
        
        view.addSubview(likeBtn)
        view.addSubview(dislikeBtn)
        
        var trailing = NSLayoutConstraint(item: likeBtn, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 1.0)
        var centerY = NSLayoutConstraint(item: likeBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 1.0)
        var height = NSLayoutConstraint(item: likeBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        var width = NSLayoutConstraint(item: likeBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        
        view.addConstraints([trailing, centerY, height, width])
        
        var leading = NSLayoutConstraint(item: dislikeBtn, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 1.0)
        centerY = NSLayoutConstraint(item: dislikeBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 1.0)
        height = NSLayoutConstraint(item: dislikeBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        width = NSLayoutConstraint(item: dislikeBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        
        view.addConstraints([leading, centerY, height, width])
        
        self.addSubview(view)
        
        trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 1.0)
        leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 1.0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 1.0)
        
        self.addConstraints([trailing, leading, top, bottom])
    }
    
}
