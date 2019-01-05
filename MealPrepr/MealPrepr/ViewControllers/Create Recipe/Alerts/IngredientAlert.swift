//
//  IngredientAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class IngredientAlert: MPViewController, MPTextFieldDelegate  {
    
    @IBOutlet weak var quantityTextField: MPTextField!
    @IBOutlet weak var ingredientTextField: MPTextField!
    @IBOutlet weak var unitTextField: MPTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var ingredient: Ingredient!
    var availableIngredients: [Ingredient]!
    var isEditingExistingIngredient = false
    var originalTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityTextField.delegate = self
        ingredientTextField.delegate = self
        unitTextField.delegate = self
        
        let _ = ingredientTextField.becomeFirstResponder()
        
        setupAlertWithIngredient()
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let ingredient = ingredientTextField.text
        let quantity = quantityTextField.text
        let unit = unitTextField.text
        
        var errorMsg = ValidationHelper.validateIngredientTitle(ingredientTitle: ingredient, availableIngredients: availableIngredients, excludingTitle: originalTitle)
        ingredientTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.checkIfDecimal(text: quantity)
        quantityTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.checkIfEmpty(text: unit)
        unitTextField.setError(errorMsg: errorMsg)
        
        if ingredientTextField.hasError || quantityTextField.hasError || unitTextField.hasError {
            //DONT Transition
            return
        }
        if self.ingredient != nil {
            self.ingredient.title = ingredient!
            self.ingredient.quantity = Decimal(string: quantity!)!
            self.ingredient.unit = unit!
        } else {
            self.ingredient = Ingredient(title: ingredient!, quantity: Decimal(string: quantity!)!, unit: unit!)
        }
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToIngredientsIdentifier, sender: self)
        
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if (textField == self.ingredientTextField) {
            let _ = self.quantityTextField.becomeFirstResponder()
        }
        else if (textField == self.quantityTextField) {
            let _ = self.unitTextField.becomeFirstResponder()
        }
        else if (textField == self.unitTextField) {
            let _ = self.unitTextField.resignFirstResponder()
        }
    }
    
    func setupAlertWithIngredient() {
        if ingredient != nil {
            isEditingExistingIngredient = true
            if let quantity = ingredient.quantity {
                quantityTextField.text = "\(quantity)"
            }
            ingredientTextField.text = ingredient.title
            unitTextField.text = ingredient.unit
            originalTitle = ingredient.title
        }
    }
}
