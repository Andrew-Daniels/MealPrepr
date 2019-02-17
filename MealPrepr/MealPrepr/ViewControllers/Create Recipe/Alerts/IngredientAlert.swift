//
//  IngredientAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class IngredientAlert: MPViewController, MPTextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var quantityTextField: MPTextField!
    @IBOutlet weak var ingredientTextField: MPTextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var ingredient: Ingredient!
    var availableIngredients: [Ingredient]!
    var isEditingExistingIngredient = false
    var originalTitle: String?
    var ingredientUnits = [String]() {
        didSet {
            if let picker = self.unitPicker {
                picker.reloadAllComponents()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityTextField.delegate = self
        ingredientTextField.delegate = self
        
        let _ = ingredientTextField.becomeFirstResponder()
        
        setupAlertWithIngredient()
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let ingredient = ingredientTextField.text
        let quantity = quantityTextField.text
        let unit = self.ingredientUnits[self.unitPicker.selectedRow(inComponent: 0)]
        
        var errorMsg = ValidationHelper.validateIngredientTitle(ingredientTitle: ingredient, availableIngredients: availableIngredients, excludingTitle: originalTitle)
        ingredientTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.checkIfDecimal(text: quantity)
        quantityTextField.setError(errorMsg: errorMsg)
        
        if ingredientTextField.hasError || quantityTextField.hasError {
            //DONT Transition
            return
        }
        if self.ingredient != nil {
            self.ingredient.title = ingredient!
            self.ingredient.quantity = Decimal(string: quantity!)!
            self.ingredient.unit = unit
        } else {
            self.ingredient = Ingredient(title: ingredient!, quantity: Decimal(string: quantity!)!, unit: unit)
        }
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToIngredientsIdentifier, sender: self)
        
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if (textField == self.ingredientTextField) {
            let _ = self.quantityTextField.becomeFirstResponder()
        }
        else if (textField == self.quantityTextField) {
            let _ = self.quantityTextField.resignFirstResponder()
        }
    }
    
    func setupAlertWithIngredient() {
        if ingredient != nil {
            isEditingExistingIngredient = true
            if let quantity = ingredient.quantity {
                quantityTextField.text = "\(quantity)"
            }
            ingredientTextField.text = ingredient.title
            originalTitle = ingredient.title
            guard let firstIndex = ingredientUnits.firstIndex(of: ingredient.unit) else { return }
            let index = ingredientUnits.startIndex.distance(to: firstIndex)
            unitPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ingredientUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.ingredientUnits[row]
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
