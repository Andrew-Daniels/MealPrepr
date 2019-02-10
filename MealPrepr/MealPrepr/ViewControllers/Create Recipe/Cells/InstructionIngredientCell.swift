//
//  InstructionIngredientCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

let redColor = UIColor(red: 242/255, green: 66/255, blue: 54/255, alpha: 1.0)

class InstructionIngredientCell: UICollectionViewCell {
    
    var ingredient: Ingredient! {
        didSet {
            if self.ingredientLabel != nil {
                self.ingredientLabel.text = ingredient.toString()
            }
        }
    }
    var ingredientLabel: UILabel!
    var imageView: UIImageView!
    var selectedIngredient: Bool = false {
        didSet {
            self.backgroundColor = selectedIngredient ? redColor : .white
            setBorder()
            if let label = self.ingredientLabel {
                label.textColor = selectedIngredient ? .white : .black
            }
            if let iv = self.imageView {
                iv.image = getImageFromIsSelected()
            }
        }
    }
    
    var isSelectable = false
    
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
        self.layer.cornerRadius = 4
        setBorder()

        ingredientLabel = UILabel()
        ingredientLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        ingredientLabel.adjustsFontSizeToFitWidth = false
        ingredientLabel.textAlignment = .center
        ingredientLabel.text = ingredient.toString()
        self.contentView.addSubview(ingredientLabel)
        ingredientLabel.sizeToFit()
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        if selectedIngredient {
            ingredientLabel.textColor = .white
        }
        
        setupConstraints()
        
    }
    
    private func setLabelAttributedString() {
        let attrIngredientString = NSMutableAttributedString(string: ingredient.toString())
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Flag_Black")
        attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        attrIngredientString.append(NSAttributedString(attachment: attachment))
        
        ingredientLabel.attributedText = attrIngredientString
    }
    
    private func setupConstraints() {
        if isSelectable {
            
            //Create imageview
            imageView = UIImageView(image: getImageFromIsSelected())
            imageView.contentMode = .scaleAspectFill
            self.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            //Imageview constraints
            var top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let width = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            var trailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -3.0)
            var bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            self.contentView.addConstraints([top, width, trailing, bottom])
            
            //New ingredientlabel constraints
            top = NSLayoutConstraint(item: ingredientLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let leading = NSLayoutConstraint(item: ingredientLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            trailing = NSLayoutConstraint(item: ingredientLabel, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1.0, constant: 3.0)
            bottom = NSLayoutConstraint(item: ingredientLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            self.contentView.addConstraints([top, leading, trailing, bottom])
            
        } else {
            
            let top = NSLayoutConstraint(item: ingredientLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let leading = NSLayoutConstraint(item: ingredientLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let trailing = NSLayoutConstraint(item: ingredientLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: ingredientLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            self.contentView.addConstraints([top, leading, trailing, bottom])
            
        }
    }
    
    private func getImageFromIsSelected() -> UIImage? {
        
        if selectedIngredient {
            return UIImage(named: "Clear_Black")?.withRenderingMode(.alwaysTemplate)
        }
        
        return UIImage(named: "Add_Alt_Black")?.withRenderingMode(.alwaysOriginal)
        
    }
    
    private func setBorder() {
        if !selectedIngredient {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.black.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
}
