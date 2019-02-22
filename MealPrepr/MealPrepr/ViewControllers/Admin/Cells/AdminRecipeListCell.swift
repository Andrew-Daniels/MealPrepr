//
//  AdminRecipeListCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/21/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class AdminRecipeListCell: UITableViewCell {
    
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
    
    private var flags: String? {
        didSet {
            self.flagCountLabel.text = flags
        }
    }
    
    private var recipeImage: UIImage? {
        didSet {
            if let i = recipeImage {
                self.recipeImageView.image = i
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
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var ingredientCountLabel: UILabel!
    @IBOutlet weak var titleBackView: RoundedUIView!
    @IBOutlet weak var ingredientBackView: RoundedUIView!
    @IBOutlet weak var flagCountBackView: UIView!
    @IBOutlet weak var flagCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    internal func initCell() {
        
        ingredientBackView.clipsToBounds = true
        ingredientBackView.layer.cornerRadius = 4
        ingredientBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        titleBackView.clipsToBounds = true
        titleBackView.layer.cornerRadius = 4
        titleBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        flagCountBackView.layer.cornerRadius = 4
        flagCountBackView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        recipeImageView.layer.cornerRadius = 4
        
        if let r = recipe {
            self.title = r.title
            self.calories = r.calServing
            self.ingredientCount = r.numIngredients
            self.recipeImage = r.photoAtIndex(index: 0)
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
            self.flags = "Flagged: \(r.flags.count) times"
        }
    }

}
