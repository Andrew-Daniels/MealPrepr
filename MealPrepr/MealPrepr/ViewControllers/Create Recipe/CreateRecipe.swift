//
//  CreateRecipe.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/10/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

let createIngredientsIdentifier = "Create-Ingredients"
let createUtensilsIdentifier = "Create-Utensils"
let createInstructionsIdentifier = "Create-Instructions"
let createPhotosIdentifier = "Create-Photos"
private let containedPhotosViewControllerSegueIdentifier = "containedPhotos"

public let mainStoryboardIdentifier = "Main"

class CreateRecipe: MPViewController, MPTextFieldDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleTextField: MPTextField!
    @IBOutlet weak var caloriesTextField: MPTextField!
    @IBOutlet weak var servingsTextField: MPTextField!
    
    enum Controller: Int {
        case Ingredients = 0
        case Utensils = 1
        case Instructions = 2
        case Photos = 3
    }
    
    private var viewControllers = [Controller: MPCreateRecipeChildController]()
    private var ingredientUnits = [String]() {
        didSet {
            if let vc = getVC(atIndex: .Ingredients) as? Ingredients {
                vc.ingredientUnits = self.ingredientUnits
            }
        }
    }
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        
        FirebaseHelper().loadIngredientUnits { (units) in
            self.ingredientUnits = units
        }
        
        titleTextField.delegate = self
        caloriesTextField.delegate = self
        servingsTextField.delegate = self
        
        setupWithRecipe()
        
        let index = Controller(rawValue: segmentedControl.selectedSegmentIndex)
        presentChildVC(atIndex: index)
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
        
        let _ = titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitle("Ingredients", forSegmentAt: 0)
        segmentedControl.setTitle("Utensils", forSegmentAt: 1)
        segmentedControl.setTitle("Instructions", forSegmentAt: 2)
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            segmentedControl.insertSegment(withTitle: "Photos", at: 3, animated: true)
        }
        
    }
    
    private func createControllerForSelectedIndex(index: Controller?) -> MPCreateRecipeChildController? {
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
        }
        guard let vc = main.instantiateViewController(withIdentifier: vcIdentifier) as? MPCreateRecipeChildController else {return nil}
        
        vc.recipe = recipe
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
        activeVC.isConnectedToInternet = isConnectedToInternet
        
        switch (atIndex) {
            
        case .Ingredients:
            if let ingredientsVC = viewControllers[.Ingredients] as? Ingredients,
                let instructionsVC = viewControllers[.Instructions] as? Instructions {
                ingredientsVC.instructions = instructionsVC.instructions
            }
            break
        case .Utensils:
            break
        case .Instructions:
            if let ingredientsVC = viewControllers[.Ingredients] as? Ingredients,
                let instructionsVC = viewControllers[.Instructions] as? Instructions {
                instructionsVC.availableIngredients = ingredientsVC.ingredients
            }
            break
        case .Photos:
            break
        }
    }
    
    @objc func segmentedControlIndexChanged() {
        guard let index = Controller(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        presentChildVC(atIndex: index)
        self.endEditing()
    }
    
    func presentVC(atIndex: Controller) {
        self.segmentedControl.selectedSegmentIndex = atIndex.rawValue
        presentChildVC(atIndex: atIndex)
    }
    
    func getVC(atIndex: Controller) -> MPViewController? {
        return self.viewControllers[atIndex]
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if (textField == self.titleTextField) {
            let _ = self.caloriesTextField.becomeFirstResponder()
        }
        else if (textField == self.caloriesTextField) {
            let _ = self.servingsTextField.becomeFirstResponder()
        }
        else if (textField == self.servingsTextField) {
            let _ = self.servingsTextField.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? Ingredients {
            vc.ingredientUnits = self.ingredientUnits
        }
        if segue.identifier == containedPhotosViewControllerSegueIdentifier {
            viewControllers[.Photos] = segue.destination as? Photos
            viewControllers[.Photos]?.recipe = recipe
        }
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if !checkForInternetConnection() {
            return
        }
        
        //Check if ingredients > 0
        //Check if title is present
        //Check if calServings is present and a number
        //Check if numServings is present and a number
        //Check if instructions are present
        //Check if photos are present
        let title = self.titleTextField.text
        var errorMsg = ValidationHelper.validateRecipeTitle(title: title)
        self.titleTextField.setError(errorMsg: errorMsg)
        
        let calories = self.caloriesTextField.text
        errorMsg = ValidationHelper.checkIfDecimal(text: calories)
        self.caloriesTextField.setError(errorMsg: errorMsg)
        
        let servings = self.servingsTextField.text
        errorMsg = ValidationHelper.checkIfDecimal(text: servings)
        self.servingsTextField.setError(errorMsg: errorMsg)
        
        var ingredients: [Ingredient]!
        var utensils: [Utensil]!
        var instructions: [Instruction]!
        var photos: [Int: UIImage]!
        
        if !self.titleTextField.hasError && !caloriesTextField.hasError && !servingsTextField.hasError {
            var errorMsg: String!
            
            if let ingredientVC = self.getVC(atIndex: .Ingredients) as? Ingredients {
                ingredients = ingredientVC.ingredients
                if let msg = ValidationHelper.validateRecipeIngredients(ingredients: ingredientVC.ingredients) {
                    errorMsg = msg + "\n"
                }
            } else if isEditingRecipe() {
                ingredients = recipe?.ingredients
            } else {
                errorMsg = ErrorHelper.getErrorMsg(errorKey: .NoIngredients)! + "\n"
            }
            
            if let utensilVC = self.getVC(atIndex: .Utensils) as? Utensils {
                utensils = utensilVC.utensils
                if let msg = ValidationHelper.validateRecipeUtensils(utensils: utensilVC.utensils) {
                    if errorMsg != nil {
                        errorMsg += msg + "\n"
                    } else {
                        errorMsg = msg + "\n"
                    }
                }
            } else if isEditingRecipe() {
                utensils = recipe?.utensils
            } else {
                if errorMsg != nil {
                    errorMsg += ErrorHelper.getErrorMsg(errorKey: .NoUtensils)! + "\n"
                } else {
                    errorMsg = ErrorHelper.getErrorMsg(errorKey: .NoUtensils)! + "\n"
                }
            }
            
            if let instructionVC = self.getVC(atIndex: .Instructions) as? Instructions {
                instructions = instructionVC.instructions
                if let msg = ValidationHelper.validateRecipeInstructions(instructions: instructionVC.instructions) {
                    if errorMsg != nil {
                        errorMsg += msg + "\n"
                    } else {
                        errorMsg = msg + "\n"
                    }
                }
            } else if isEditingRecipe() {
                instructions = recipe?.instructions
            } else {
                if errorMsg != nil {
                    errorMsg += ErrorHelper.getErrorMsg(errorKey: .NoInstructions)! + "\n"
                } else {
                    errorMsg = ErrorHelper.getErrorMsg(errorKey: .NoInstructions)! + "\n"
                }
            }
            
            if let photosVC = self.getVC(atIndex: .Photos) as? Photos {
                photos = photosVC.images
                if let msg = ValidationHelper.validateRecipePhotos(photos: photosVC.images) {
                    if errorMsg != nil {
                        errorMsg += msg + "\n"
                    } else {
                        errorMsg = msg + "\n"
                    }
                }
            } else {
                if errorMsg != nil {
                    errorMsg += ErrorHelper.getErrorMsg(errorKey: .NoPhotos)! + "\n"
                } else {
                    errorMsg = ErrorHelper.getErrorMsg(errorKey: .NoPhotos)! + "\n"
                }
            }
            
            if errorMsg != nil {
                MPAlertController.show(message: errorMsg, type: .Standard, presenter: self)
            } else {
               //There aren't any errors perform save here
                
                var recipeToSave: Recipe!
                
                if let r = self.recipe {
                    r.update(title: title!, calServing: calories!, numServings: servings!, ingredients: ingredients, utensils: utensils, instructions: instructions, photos: photos)
                    recipeToSave = r
                } else {
                    recipeToSave = Recipe(title: title!, calServing: calories!, numServings: servings!, ingredients: ingredients, utensils: utensils, instructions: instructions, photos: photos, creator: account.UID)
                }
                
                self.startLoading(withText: "Saving")
                recipeToSave.save { (success) in
                    if success {
                        self.finishLoading(completionHandler: { (finished) in
                            //Do Animation to dismiss this view controller
                            let homeVC = self.navigationController?.viewControllers.first(where: { (vc) -> Bool in
                                if vc is Home {
                                    return true
                                }
                                return false
                            })
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                                // Put your code which should be executed with a delay here
                                UIView.animate(withDuration: 0.2, animations: {
                                    if let collectionView = (homeVC as! Home).collectionView {
                                        if collectionView.numberOfItems(inSection: 0) > 0 {
                                            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
                                        }
                                    }
                                })
                            })
                            (homeVC as! Home).recipes.removeAll(where: { (r) -> Bool in
                                return r.GUID == recipeToSave.GUID
                            })
                            (homeVC as! Home).recipes.insert(recipeToSave, at: 0)
                            self.navigationController?.popToRootViewController(animated: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
                                // Put your code which should be executed with a delay here
                                if let collectionView = (homeVC as! Home).collectionView {
                                    if collectionView.numberOfItems(inSection: 0) > 0 {
                                        if self.isEditingRecipe() {
                                            collectionView.reloadData()
                                        } else {
                                            collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                                        }
                                    }
                                }
                            })
                        })
                    } else {
                        self.finishLoadingWithError(completionHandler: { (finished) in
                            //Do stuff here
                        })
                    }
                }
            }
        }
    }
    
    override func endEditing() {
        super.endEditing()
        
        let _ = titleTextField.resignFirstResponder()
        let _ = caloriesTextField.resignFirstResponder()
        let _ = servingsTextField.resignFirstResponder()
    }
    
    override func connectionStateDidChange() {
        for v in viewControllers.values {
            v.isConnectedToInternet = isConnectedToInternet
        }
    }
    
    private func setupWithRecipe() {
        if let r = recipe {
            self.navigationItem.title = "Editing Recipe"
            self.titleTextField.text = r.title
            self.caloriesTextField.text = r.calServing
            self.servingsTextField.text = r.numServings
        }
    }
    
    private func isEditingRecipe() -> Bool {
        return recipe != nil
    }
}
