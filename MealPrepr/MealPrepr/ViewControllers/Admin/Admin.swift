//
//  Admin.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let cellIdentifier = "adminFlagListCell"
private let flaggedRecipeDetailSegueIdentifier = "flaggedRecipeDetail"

class Admin: MPViewController, UITableViewDelegate, UITableViewDataSource, RecipeDelegate {

    var recipes = [Recipe]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper().loadRecipeGUIDsWithFlags { (recipeGUIDs) in
            
            for guid in recipeGUIDs {
                
                FirebaseHelper().loadRecipe(guid: guid, completionHandler: { (recipe) in
                    self.recipes.append(recipe)
                    
                    if self.recipes.count == recipeGUIDs.count {
                        self.reloadTableView()
                    }
                })
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AdminRecipeListCell
        
        let recipe = self.recipes[indexPath.row]
        
        cell.recipe = recipe
        recipe.recipeDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recipe = self.recipes[indexPath.row]
        performSegue(withIdentifier: flaggedRecipeDetailSegueIdentifier, sender: recipe)
        
    }
    
    func photoDownloaded(sender: Recipe) {
        let firstIndex = self.recipes.firstIndex { (recipe) -> Bool in
            if recipe.GUID == sender.GUID {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        let row = recipes.startIndex.distance(to: nonNilIndex)
        let indexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == flaggedRecipeDetailSegueIdentifier {
            
            guard let vc = segue.destination as? RecipeManager else { return }
            vc.recipe = sender as? Recipe
            vc.admin = self
        }
    }
    
    func reloadTableView() {
        
        self.tableView.reloadData()
        self.tableView.isHidden = self.recipes.count == 0
        self.emptyView.isHidden = self.recipes.count > 0
        
    }

}
