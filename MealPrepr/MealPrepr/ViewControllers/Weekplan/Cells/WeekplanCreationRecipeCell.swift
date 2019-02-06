//
//  WeekplanCreationRecipeCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/3/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class WeekplanCreationRecipeCell: HomeRecipesCell {
    
    var weekplanCellDelegate: WeekplanCreationCellDelegate?
    var isContainedInWeekplan: Bool!
    
    @IBOutlet weak var editBtn: UIButton!
    
    
    @IBAction func editBtnClicked(_ sender: Any) {
        weekplanCellDelegate?.editBtnClicked(recipe: self.recipe)
    }
    
    override func initCell() {
        super.initCell()
        
        var image: UIImage?
        
        if isContainedInWeekplan {
            image = UIImage(named: "Remove_White")
            
        } else {
            image = UIImage(named: "Add")
            
        }
        editBtn.setImage(image, for: .normal)
    }
    
}
