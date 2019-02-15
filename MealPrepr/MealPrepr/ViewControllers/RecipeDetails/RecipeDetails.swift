//
//  RecipeDetails.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/6/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let photosVCSegueIdentifier = "containedPhotos"
private let categorySelectorSegueIdentifier = "categorySelector"
private let flagSelectorSegueIdentifier = "flagSelector"
private let reviewsIdentifier = "RecipeDetails-Reviews"

class RecipeDetails: MPViewController, CategorySelectorDelegate, FlagSelectorDelegate, ReviewDelegate {
    
    enum Controller: Int {
        case Instructions = 0
        case Utensils = 1
        case Ingredients = 2
        case Reviews = 3
        case Photos = 4
    }
    
    var recipe: Recipe!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesServingLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonBottomConstraint: NSLayoutConstraint!
    
    private var viewControllers = [Controller: MPViewController]()
    private var reviewAccountsLoaded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesImageView.image = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
        likesImageView.tintColor = redColor
        
        let index = Controller(rawValue: segmentedControl.selectedSegmentIndex)
        presentChildVC(atIndex: index)
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupWithRecipe()
        setupBarButtons()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            bottomButtonBottomConstraint.constant = isKeyboardShowing ? (-keyboardFrame.height) + 34 + (self.tabBarController?.tabBar.frame.height ?? 0) : 0
            containerViewHeightConstraint.constant = isKeyboardShowing ? 50 : 200
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createControllerForSelectedIndex(index: Controller?) -> MPViewController? {
        
        guard let index = index else { return nil }
        var vcIdentifier: String!
        var storyboardIdentifier: String = mainStoryboardIdentifier
        
        switch (index) {
            
        case .Ingredients:
            vcIdentifier = createIngredientsIdentifier
        case .Utensils:
            vcIdentifier = createUtensilsIdentifier
        case .Instructions:
            vcIdentifier = createInstructionsIdentifier
        case .Photos:
            vcIdentifier = createPhotosIdentifier
        case .Reviews:
            vcIdentifier = reviewsIdentifier
            storyboardIdentifier = "RecipeDetails"
        }
        
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? MPViewController else { return nil }
        
        viewControllers[index] = vc
        
        return vc
    }
    
    private func presentChildVC(atIndex: Controller?) {
        guard let atIndex = atIndex else { return }
        var vc = viewControllers[atIndex]
        if vc == nil {
            vc = createControllerForSelectedIndex(index: atIndex)
        }
        
        guard let activeVC = vc else { return }
        addChild(activeVC)
        containerView.addSubview(activeVC.view)
        activeVC.constrainToContainerView()
        
        activeVC.didMove(toParent: self)
        
        switch (atIndex) {
            
        case .Ingredients:
            if let ingredientsVC = viewControllers[.Ingredients] as? Ingredients {
                ingredientsVC.ingredients = recipe.ingredients
                ingredientsVC.readOnly = true
            }
            break
        case .Utensils:
            if let utensilVC = viewControllers[.Utensils] as? Utensils {
                utensilVC.utensils = recipe.utensils
                utensilVC.readOnly = true
            }
            break
        case .Instructions:
            if let instructionsVC = viewControllers[.Instructions] as? Instructions {
                instructionsVC.instructions = recipe.instructions
                instructionsVC.readOnly = true
            }
            break
        case .Photos:
            break
        case .Reviews:
            if let reviewsVC = viewControllers[.Reviews] as? Reviews {
                reviewsVC.recipe = self.recipe
                reviewsVC.account = self.account
            }
            break
        }
    }

    private func setupWithRecipe() {
        if let r = recipe {
            if r.totalCookTime.hours == 0 {
                self.cookLabel.text = "\(r.totalCookTime.minutes)m cook"
            } else {
                self.cookLabel.text = "\(r.totalCookTime.hours)hr\(r.totalCookTime.minutes)m cook"
            }
            if r.totalPrepTime.hours == 0 {
                self.prepLabel.text = "\(r.totalPrepTime.minutes)m prep"
            } else {
                self.prepLabel.text = "\(r.totalPrepTime.hours)hr\(r.totalPrepTime.minutes)m prep"
            }
            if let d = r.dateCreated {
                self.dateCreatedLabel.text = "Date Created: \(d.detail)"
            }
            self.servingLabel.text = r.numServings
            self.caloriesServingLabel.text = r.calServing
            
            if self.recipe.reviews.count == 0 {
                FirebaseHelper().loadReviews(recipe: self.recipe, reviewDelegate: self) { (loaded) in
                    
                }
            }
            
        }
    }
    
    func reviewProfileImageLoaded(sender: Review) {
        
        if let vc = viewControllers[.Reviews] as? Reviews {
            let firstIndex = self.recipe.reviews.firstIndex { (review) -> Bool in
                if review.guid == sender.guid {
                    return true
                }
                return false
            }
            guard let nonNilIndex = firstIndex else { return }
            let row = recipe.reviews.startIndex.distance(to: nonNilIndex)
            let indexPath = IndexPath(row: row, section: 0)
            vc.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func reviewAccountLoaded() {
        
        reviewAccountsLoaded += 1
        
        if let vc = viewControllers[.Reviews] as? Reviews {
            
            if reviewAccountsLoaded == self.recipe.reviewCount {
                vc.tableView.reloadData()
            }
            
        }
        
    }
    
    @IBAction func favoritesBtnClicked(_ sender: Any) {
        if !checkForGuestAccount() && checkForInternetConnection() {
            (sender as! UIButton).isSelected = true
            self.account.viewingCategories()
            performSegue(withIdentifier: categorySelectorSegueIdentifier, sender: sender)
        }
    }
    @IBAction func flagBtnClicked(_ sender: Any) {
        if !checkForGuestAccount() && checkForInternetConnection() {
            (sender as! UIButton).isSelected = true
            performSegue(withIdentifier: flagSelectorSegueIdentifier, sender: sender)
        }
    }
    
    @objc func segmentedControlIndexChanged() {
        guard let index = Controller(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        presentChildVC(atIndex: index)
        
        if let vc = viewControllers[.Reviews] {
            vc.endEditing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier) {
        case photosVCSegueIdentifier:
            if let vc = segue.destination as? Photos {
                vc.recipe = recipe
                vc.readOnly = true
            }
            return
        case categorySelectorSegueIdentifier:
            if let vc = segue.destination as? CategorySelector {
                vc.delegate = self
                vc.sender = sender
                vc.alertDelegate = self
            }
            return
        case flagSelectorSegueIdentifier:
            if let vc = segue.destination as? FlagSelector {
                vc.delegate = self
                vc.sender = sender
                vc.alertDelegate = self
            }
            return
        default:
            return
        }
    }
    
    func setupBarButtons() {
        if account.UID == self.recipe.creatorUID {
            let deleteBtn = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(deleteBarBtnClicked))
            deleteBtn.image = UIImage(named: "Delete_White")?.withRenderingMode(.alwaysTemplate)
            deleteBtn.tintColor = UIColor.white
            
            let editBtn = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(editBarBtnClicked))
            editBtn.image = UIImage(named: "Edit_White")?.withRenderingMode(.alwaysTemplate)
            editBtn.tintColor = UIColor.white
            
            self.navigationItem.rightBarButtonItems = [editBtn, deleteBtn]
        }
    }
    
    @objc func deleteBarBtnClicked() {
        let title = "Delete Recipe"
        let actionTitle = "Delete"
        let alert = UIAlertController(title: title, message: "This recipe will be removed from searchable recipes, but will stay in user's favorites lists, would you like to continue?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteRecipeAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            self.recipe.delete()
            if let nav =  self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        alert.addAction(deleteRecipeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editBarBtnClicked() {
        let createRecipe = UIStoryboard(name: "CreateRecipe", bundle: nil)
        guard let vc = createRecipe.instantiateViewController(withIdentifier: "UIViewController-eGc-Uf-BP7") as? CreateRecipe else { return }
        vc.recipe = recipe
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func categorySelected(category: String) {
        FirebaseHelper().saveRecipeToCategory(account: self.account, category: category, recipe: self.recipe)
        if let tabBarVC = self.tabBarController as? HomeTabBarController {
            if let catNVC = tabBarVC.getVC(controller: .Categories) as? CategoriesNavigationController {
                if let catVC = catNVC.viewControllers.first as? Categories, let _ = catVC.collectionView {
                    catVC.reloadRecipes()
                }
            }
        }
    }
    
    func flagSelected(reason: String) {
        let flag = Flag()
        flag.date = Date()
        flag.recipe = recipe
        flag.issuer = self.account
        flag.reason = reason
        
        flag.save()
    }
}
