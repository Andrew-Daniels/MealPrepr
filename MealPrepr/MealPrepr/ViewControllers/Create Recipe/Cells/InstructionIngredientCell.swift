//
//  InstructionIngredientCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class InstructionIngredientCell: UICollectionViewCell {
    
    var ingredient: Ingredient! {
        didSet {
            if self.ingredientLabel != nil {
                self.ingredientLabel.text = ingredient.toString()
            }
        }
    }
    var ingredientLabel: UILabel!
    var selectedIngredient: Bool = false {
        didSet {
            let redColor = UIColor(red: 242/255, green: 66/255, blue: 54/255, alpha: 1.0)
            self.backgroundColor = selectedIngredient ? redColor : .white
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
        self.layer.cornerRadius = 8
        ingredientLabel = UILabel()
        ingredientLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        ingredientLabel.adjustsFontSizeToFitWidth = true
        ingredientLabel.textAlignment = .center
        ingredientLabel.text = ingredient.toString()
        self.contentView.addSubview(ingredientLabel)
        ingredientLabel.sizeToFit()
        //self.contentView.bounds.size = ingredientLabel.bounds.size
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
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
