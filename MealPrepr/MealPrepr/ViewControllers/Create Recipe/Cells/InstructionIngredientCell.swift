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
    var ingredientLabel: UILabel!
    var selectedIngredient: Bool = false {
        didSet {
            self.backgroundColor = selectedIngredient ? .red : .white
            if let label = self.ingredientLabel {
                label.textColor = selectedIngredient ? .white : .black
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initInstructionIngredientCell()
    }
    
    func initInstructionIngredientCell() {
        if ingredientLabel != nil {
            return
        }
        ingredientLabel = UILabel()
        ingredientLabel.textAlignment = .center
        ingredientLabel.text = ingredient.toString()
        self.contentView.addSubview(ingredientLabel)
        ingredientLabel.sizeToFit()
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        if selectedIngredient {
            ingredientLabel.textColor = .white
        }
        let top = NSLayoutConstraint(item: ingredientLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: ingredientLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: ingredientLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: ingredientLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.contentView.addConstraints([top, leading, trailing, bottom])
    }
    
}
