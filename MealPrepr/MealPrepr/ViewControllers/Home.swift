//
//  Home.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

let recipeDetailsStoryboardIdentifier = "RecipeDetails"

class Home: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, RecipeDelegate {
    
    @IBOutlet weak var collectionView: MPCollectionView!
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper().loadRecipes(recipeDelegate: self) { (data) in
            self.recipes = data
            self.collectionView.reloadData()
        }
        
        //Setup UIBarButtonItems
        if (account.userLevel == .Guest) {
            let createAccountBtn = UIBarButtonItem(title: "Create Account", style: .done, target: self, action: #selector(createAccountBtnClicked))
            createAccountBtn.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = createAccountBtn
        } else {
            let logoutBtn = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutBtnClicked))
            logoutBtn.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = logoutBtn
        }
        
        //Setup SearchController
        hasSearchController = true
        setupSearchControllerDelegates(searchResultsUpdater: self, searchDelegate: self)
        
        //Setup UINavigationBarTitleView
        let imageViewTitle: UIImageView = UIImageView(image: UIImage(named: "Meal-Prepr-Logo"))
        imageViewTitle.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageViewTitle
        imageViewTitle.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    }
    
    @objc func logoutBtnClicked() {
        do {
            
            let manager = FBSDKLoginManager()
            manager.logOut()
            
            try Auth.auth().signOut()
            
            performSegue(withIdentifier: backToLoginSegueIdentifier, sender: nil)
        } catch {
            print("Error when trying to log user out.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecipes", for: indexPath) as! HomeRecipesCell
        let recipe = recipes[indexPath.row]
        recipe.recipeDelegate = self
        cell.recipe = recipe
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.collectionViewCellWidth = 170.0
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        self.showRecipeDetails(recipe: recipe)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (account.userLevel == .Guest && segue.identifier != backToSignUpSegueIdentifier) {
            MPAlertController.show(message: "You must sign in first before you can use this feature.", type: .CreateAccount, presenter: self)
        }
        if segue.identifier == createRecipeSegueIdentifier {
            if let vc = segue.destination as? CreateRecipe {
                vc.hidesBottomBarWhenPushed = true
            }
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
        self.collectionView.reloadItems(at: [indexPath])
    }

    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        print(GUID)
    }
}
