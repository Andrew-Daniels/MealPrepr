//
//  RecipeManager.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/22/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let cellIdentifier = "recipeManagerCell"

class RecipeManager: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var ingredientBackView: RoundedUIView!
    @IBOutlet weak var calServLabel: UILabel!
    @IBOutlet weak var ingredientCountLabel: UILabel!
    @IBOutlet weak var recipeTitleBackView: RoundedUIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var deleteRecipeBtn: UIButton!
    @IBOutlet weak var clearFlagsBtn: UIButton!
    var recipe: Recipe!
    var admin: Admin?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWithRecipe()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.flags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FlagCell
        
        let flag = recipe.flags[indexPath.row]
    
        cell.flag = flag
        return cell
    }
    
    
    @IBAction func clearFlagsBtnClicked(_ sender: Any) {
        
        self.startLoading(withText: "Clearing..") { (started) in
            
            var flagDeletionCount = 0
            
            for flag in self.recipe.flags {
                
                flag.delete { (completed) in
                    
                    flagDeletionCount += 1
                    if flagDeletionCount == self.recipe.flags.count {
                        
                        self.finishLoading(completionHandler: { (finished) in
                            if let parent = self.admin {
                                parent.recipes.removeAll(where: { (r) -> Bool in
                                    return r.GUID == self.recipe.GUID
                                })
                                parent.tableView.reloadData()
                            }
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        
        self.startLoading(withText: "Deleting..") { (started) in
            
            var flagDeletionCount = 0
            
            for flag in self.recipe.flags {
                
                flag.delete { (completed) in
                    
                    flagDeletionCount += 1
                    if flagDeletionCount == self.recipe.flags.count {
                        
                        self.recipe.delete()
                        
                        self.finishLoading(completionHandler: { (finished) in
                            if let parent = self.admin {
                                parent.recipes.removeAll(where: { (r) -> Bool in
                                    return r.GUID == self.recipe.GUID
                                })
                                parent.reloadTableView()
                            }
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    private func setupWithRecipe() {
        
        ingredientBackView.clipsToBounds = true
        ingredientBackView.layer.cornerRadius = 4
        ingredientBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        recipeTitleBackView.clipsToBounds = true
        recipeTitleBackView.layer.cornerRadius = 4
        recipeTitleBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        recipeImageView.layer.cornerRadius = 4
        
        if let r = recipe {
            self.recipeTitle.text = r.title
            self.calServLabel.text = r.calServing
            self.ingredientCountLabel.text = r.numIngredients.description
            self.recipeImageView.image = r.photoAtIndex(index: 0)
            if r.totalCookTime.hours == 0 {
                self.cookLabel.text = "\(r.totalCookTime.minutes)m"
            } else {
                self.cookLabel.text = "\(r.totalCookTime.hours)hr\(r.totalCookTime.minutes)m"
            }
            if r.totalPrepTime.hours == 0 {
                self.prepLabel.text = "\(r.totalPrepTime.minutes)m"
            } else {
                self.prepLabel.text = "\(r.totalPrepTime.hours)hr\(r.totalPrepTime.minutes)m"
            }
        }
    }
    
}
