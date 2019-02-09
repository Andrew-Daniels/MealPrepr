//
//  HomeRecipesCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class HomeRecipesCell: UICollectionViewCell {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    private var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    private var calories: String? {
        didSet {
            self.caloriesLabel.text = calories
        }
    }
    
    private var prep: String? {
        didSet {
            self.prepLabel.text = prep
        }
    }
    
    private var cook: String? {
        didSet {
            self.cookLabel.text = cook
        }
    }
    
    private var image: UIImage? {
        didSet {
            if let i = image {
                self.imageView.image = i
            }
        }
    }
    
    private var ingredientCount: Int = 0 {
        didSet {
            ingredientCountLabel.text = "\(ingredientCount)"
        }
    }
    
    public var recipe: Recipe! {
        didSet {
            initCell()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var ingredientCountLabel: UILabel!
    @IBOutlet weak var titleBackView: RoundedUIView!
    @IBOutlet weak var ingredientBackView: RoundedUIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func initCell() {
        
        ingredientBackView.clipsToBounds = true
        ingredientBackView.layer.cornerRadius = 5
        ingredientBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        titleBackView.clipsToBounds = true
        titleBackView.layer.cornerRadius = 5
        titleBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if let r = recipe {
            self.title = r.title
            self.calories = r.calServing
            self.ingredientCount = r.numIngredients
            self.image = r.photoAtIndex(index: 0)
            if r.totalCookTime.hours == 0 {
                self.cook = "\(r.totalCookTime.minutes)m"
            } else {
                self.cook = "\(r.totalCookTime.hours)hr\(r.totalCookTime.minutes)m"
            }
            if r.totalPrepTime.hours == 0 {
                self.prep = "\(r.totalPrepTime.minutes)m"
            } else {
                self.prep = "\(r.totalPrepTime.hours)hr\(r.totalPrepTime.minutes)m"
            }
        }
    }
    
}
