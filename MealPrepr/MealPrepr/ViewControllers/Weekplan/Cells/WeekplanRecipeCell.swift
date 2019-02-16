//
//  WeekplanRecipeCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/2/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class WeekplanRecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var completedImage: UIImageView!
    public var recipe: Recipe! {
        didSet {
            initWeekplanRecipeCellWithRecipe()
        }
    }

    private func initWeekplanRecipeCellWithRecipe() {
        if let recipe = recipe {
            recipeImageView.image = recipe.photoAtIndex(index: 0)
            recipeImageView.layer.cornerRadius = 4
            recipeImageView.translatesAutoresizingMaskIntoConstraints = false
            recipeTitleLabel.text = recipe.title
            
            if recipe.totalCookTime.hours == 0 {
                self.cookLabel.text = "cook \(recipe.totalCookTime.minutes)m"
            } else {
                self.cookLabel.text = "cook \(recipe.totalCookTime.hours)hr\(recipe.totalCookTime.minutes)m"
            }
            if self.recipe.totalPrepTime.hours == 0 {
                self.prepLabel.text = "prep \(recipe.totalPrepTime.minutes)m"
            } else {
                self.prepLabel.text = "prep \(recipe.totalPrepTime.hours)hr\(recipe.totalPrepTime.minutes)m"
            }
            self.completedImage.image = UIImage(named: "Done_Black")?.withRenderingMode(.alwaysTemplate)
            self.completedImage.tintColor = redColor
            self.completedView.isHidden = recipe.weekplanStatus == .Active
        }
    }
}
