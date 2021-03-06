//
//  Favorites.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/14/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let categoryAlertSegueIdentifier = "CategoryAlert"
private let cellIdentifier = "HomeRecipes"
private let popoverSegueIdentifier = "categorySelectorPopover"
private let selectorSegueIdentifier = "categorySelectorModal"

class Categories: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, RecipeDelegate, UICollectionViewDelegateFlowLayout, CategorySelectorDelegate {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var recipes = [Recipe]()
    var category = "Favorites"
    private var isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        FirebaseHelper().loadRecipesForCategory(account: self.account, category: self.category) { (recipes) in
            self.recipes = recipes
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = checkForGuestAccount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeRecipesCell
        let recipe = self.recipes[indexPath.row]
        cell.recipe = recipe
        recipe.recipeDelegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.collectionViewCellWidth = 192.0
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.row]
        self.showRecipeDetails(recipe: recipe)
    }
    
    @IBAction func backToCategories(segue: UIStoryboardSegue) {
    }
    
    @IBAction func favoritesBtnClicked(_ sender: Any) {
        
        if !checkForInternetConnection() {
            return
        }
        
        if let sender = sender as? UIButton {
            sender.isSelected = true
        }
        performSegue(withIdentifier: selectorSegueIdentifier, sender: sender)
        
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
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case selectorSegueIdentifier:
            if let vc = segue.destination as? CategorySelector {
                vc.delegate = self
                vc.sender = sender
                vc.alertDelegate = self
            }
            break
        default:
            break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkForInternetConnection()
    }
    
    func categorySelected(category: String?) {
        
        if let c = category {
            self.category = c
            
            reloadRecipes()
        }
        
    }
    
    public func reloadRecipes() {
        FirebaseHelper().loadRecipesForCategory(account: self.account, category: self.category) { (recipes) in
            self.filterButton.setTitle(self.category, for: .normal)
            self.recipes = recipes
            self.collectionView.reloadData()
        }
    }
    

}
