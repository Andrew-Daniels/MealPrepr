//
//  InstructionIngredientCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class InstructionIngredientCell: UICollectionViewCell {
    
    var ingredient: Ingredient!
    var ingredientBtn: UIButton!
    var enabled: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initInstructionIngredientCell()
    }
    
    func initInstructionIngredientCell() {
        if ingredientBtn != nil {
            return
        }
        ingredientBtn = UIButton()
        ingredientBtn.setTitle(ingredient.title, for: .normal)
        self.contentView.addSubview(ingredientBtn)
        ingredientBtn.sizeToFit()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        ingredientBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: ingredientBtn, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: ingredientBtn, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: ingredientBtn, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: ingredientBtn, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.contentView.addConstraints([top, leading, trailing, bottom])
        
    }
    
}
