//
//  CreateWeekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/3/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let weekplanCreationCellIdentifier = "weekplanCreationRecipeCell"

class CreateWeekplan: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, RecipeDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var currentWeekPlanCollectionView: UICollectionView!
    
    @IBOutlet weak var recipeListCollectionView: UICollectionView!
    
    
    @IBOutlet weak var randomizeBtn: UIButton!
    @IBOutlet weak var favoritesBtn: UIButton!
    private var allRecipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveRecipes()
    }

    @IBAction func randomizeBtnClicked(_ sender: Any) {
    }
    
    @IBAction func favoritesBtnClicked(_ sender: Any) {
    }
    @IBAction func saveBtnClicked(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekplanCreationCellIdentifier, for: indexPath) as! WeekplanCreationRecipeCell
        
        let recipe = allRecipes[indexPath.row]
        cell.imageView.layer.cornerRadius = 12
        cell.imageView.clipsToBounds = true
        cell.recipe = recipe
        recipe.recipeDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = allRecipes[indexPath.row]
        showRecipeDetails(recipe: recipe)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.collectionViewCellWidth = 190.0
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    public func retrieveRecipes() {
        FirebaseHelper().loadRecipes(recipeDelegate: self) { (data) in
            self.allRecipes = data
            self.recipeListCollectionView.reloadData()
        }
    }
    
    func photoDownloaded(sender: Recipe) {
        let firstIndex = self.allRecipes.firstIndex { (recipe) -> Bool in
            if recipe.GUID == sender.GUID {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        let row = allRecipes.startIndex.distance(to: nonNilIndex)
        let indexPath = IndexPath(row: row, section: 0)
        self.recipeListCollectionView.reloadItems(at: [indexPath])
    }
    
    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
}
