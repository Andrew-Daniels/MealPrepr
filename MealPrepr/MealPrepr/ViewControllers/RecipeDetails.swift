//
//  RecipeDetails.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/6/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let photosVCSegueIdentifier = "containedPhotos"

class RecipeDetails: MPViewController {
    
    var recipe: Recipe!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWithRecipe()
    }

    private func setupWithRecipe() {
        if let recipe = recipe {
            let prep = recipe.totalPrepTime
            self.prepLabel.text = "\(prep.hours)h\(prep.minutes)m"
            let cook = recipe.totalCookTime
            self.cookLabel.text = "\(cook.hours)h\(cook.minutes)m"
        }
    }
    @IBAction func favoritesBtnClicked(_ sender: Any) {
    }
    @IBAction func flagBtnClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case photosVCSegueIdentifier:
            if let vc = segue.destination as? Photos {
                vc.recipe = recipe
                vc.readOnly = true
            }
            return
        default:
            return
        }
    }
}
