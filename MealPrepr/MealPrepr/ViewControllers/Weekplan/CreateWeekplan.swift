//
//  CreateWeekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/3/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let weekplanCreationCellIdentifier = "weekplanCreationRecipeCell"

class CreateWeekplan: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, RecipeDelegate, UICollectionViewDelegateFlowLayout, WeekplanCreationCellDelegate, CategorySelectorDelegate {

    @IBOutlet weak var currentWeekPlanCollectionView: UICollectionView!
    @IBOutlet weak var recipeListCollectionView: UICollectionView!
    @IBOutlet weak var randomizeBtn: UIButton!
    @IBOutlet weak var favoritesBtn: UIButton!
    private var recipes = [Recipe]()
    var weekplan = WeekplanModel()
    //private var weekplanRecipes = [Recipe]()
    private var selectedCategory: String!
    
    private enum CollectionView: Int {
        case RecipeList = 0
        case Weekplan = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveRecipes(category: "All")
    }

    @IBAction func randomizeBtnClicked(_ sender: Any) {
    }
    
    @IBAction func favoritesBtnClicked(_ sender: Any) {
        
        let categories = UIStoryboard(name: "Categories", bundle: nil)
        let vc = categories.instantiateViewController(withIdentifier: "CategorySelector") as! CategorySelector
        vc.delegate = self
        vc.account = self.account
        vc.showsAll = true
        vc.alertDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func saveBtnClicked(_ sender: Any) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let cV = CollectionView(rawValue: collectionView.tag) else { return 0 }
        return numberOfItemsInSection(collectionView: cV)
        
    }
    
    private func numberOfItemsInSection(collectionView: CollectionView) -> Int {
        
        switch collectionView {
        case .RecipeList:
            return recipes.count
        case .Weekplan:
            return weekplan.recipes?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekplanCreationCellIdentifier, for: indexPath) as! WeekplanCreationRecipeCell
        
        var recipe: Recipe? = Recipe()
        var isContainedInWeekplan = false
        
        guard let cV = CollectionView(rawValue: collectionView.tag) else { return cell }
        
        switch cV {
        case .RecipeList:
            recipe = recipes[indexPath.row]
            isContainedInWeekplan = weekplan.recipes?.contains(where: { (r) -> Bool in
                return r.GUID == recipe?.GUID
            }) ?? false
        case .Weekplan:
            recipe = weekplan.recipes?[indexPath.row]
            isContainedInWeekplan = true
        }

        cell.imageView.layer.cornerRadius = 12
        cell.imageView.clipsToBounds = true
        cell.isContainedInWeekplan = isContainedInWeekplan
        cell.recipe = recipe
        recipe?.recipeDelegate = self
        cell.weekplanCellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cV = CollectionView(rawValue: collectionView.tag) else { return }
        
        var recipe = Recipe()
        
        switch cV {
        case .RecipeList:
            recipe = recipes[indexPath.row]
        case .Weekplan:
            guard let r = weekplan.recipes?[indexPath.row] else { return }
            recipe = r
        }
        
        
        showRecipeDetails(recipe: recipe)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.collectionViewCellWidth = 190.0
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    public func retrieveRecipes(category: String = "All") {
        
        if category != selectedCategory {
            
            if category == "All" {
                FirebaseHelper().loadRecipes(recipeDelegate: self) { (data) in
                    self.favoritesBtn.setTitle(category, for: .normal)
                    self.recipes = data
                    self.recipeListCollectionView.reloadData()
                }
            } else {
                FirebaseHelper().loadRecipesForCategory(account: self.account, category: category) { (data) in
                    self.favoritesBtn.setTitle(category, for: .normal)
                    self.recipes = data
                    self.recipeListCollectionView.reloadData()
                }
            }
            
            selectedCategory = category
        }
        
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
        self.recipeListCollectionView.reloadItems(at: [indexPath])
    }
    
    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
    func editBtnClicked(recipe: Recipe) {
        //Remove recipe from weekplan list - if exists
        //Change image on recipe list
        //Reload collectionviews
        
        if weekplan.recipes?.contains(where: { (r) -> Bool in
            return r.GUID == recipe.GUID
        }) ?? false {
            weekplan.recipes?.removeAll { (r) -> Bool in
                return r.GUID == recipe.GUID
            }
        } else {
            weekplan.recipes?.append(recipe)
        }
        
        currentWeekPlanCollectionView.reloadData()
        recipeListCollectionView.reloadData()
    }
    
    func categorySelected(category: String) {
        retrieveRecipes(category: category)
    }
    
}
