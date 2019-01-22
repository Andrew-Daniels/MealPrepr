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
    
    private var viewControllers = [Controller: MPViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = Controller(rawValue: segmentedControl.selectedSegmentIndex)
        presentChildVC(atIndex: index)
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
        
        setupWithRecipe()
        setupBarButtons()
    }
    
    private func createControllerForSelectedIndex(index: Controller?) -> MPViewController? {
        let main = UIStoryboard(name: mainStoryboardIdentifier, bundle: nil)
        guard let index = index else { return nil }
        var vcIdentifier: String!
        
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
            break
        }
        guard let vc = main.instantiateViewController(withIdentifier: vcIdentifier) as? MPViewController else { return nil }
        
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
        }
    }
    @IBAction func favoritesBtnClicked(_ sender: Any) {
    }
    @IBAction func flagBtnClicked(_ sender: Any) {
    }
    
    @objc func segmentedControlIndexChanged() {
        guard let index = Controller(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        presentChildVC(atIndex: index)
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
    }
    
    @objc func editBarBtnClicked() {
    }
}
