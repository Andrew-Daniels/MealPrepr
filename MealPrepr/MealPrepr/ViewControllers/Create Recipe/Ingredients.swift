//
//  Ingredients.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let ingredientCellIdentifier = "IngredientCell"
public let backToIngredientsIdentifier = "backToIngredients"
private let ingredientAlertSegueIdentifier = "ingredientAlert"
private let editIngredientAlertSegueIdentifier = "EditIngredient"
private let cancelledEditSegueIdentifier = "cancelledEdit"

class Ingredients: MPCreateRecipeChildController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ingredients: [Ingredient]! {
        didSet {
            self.tableViewModelDidChange(modelCount: ingredients.count)
        }
    }
    var instructions: [Instruction]!
    
    var ingredientBeingEdited: Ingredient!
    var ingredientIndexBeingEdited: IndexPath!
    var isEditingExistingIngredient = false
    var ingredientAlert: IngredientAlert?
    var ingredientUnits = [String]() {
        didSet {
            if let alertVC = self.ingredientAlert {
                alertVC.ingredientUnits = self.ingredientUnits
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let r = recipe, ingredients == nil, instructions == nil {
            self.instructions = r.instructions
            self.ingredients = r.ingredients
        } else if ingredients == nil {
            ingredients = []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier) as! IngredientCell
        cell.ingredient = ingredients[indexPath.row]
        
        if readOnly {
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !readOnly
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle) {
            
        case .none:
            break
        case .delete:
            if (!anyInstructionContainsIngredient(atIndex: indexPath)) {
                if ingredients.count == 1 {
                    self.tableView.setEditing(false, animated: true)
                }
                ingredients.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                //Alert User that you can't delete an ingredient that an instruction contains.
                MPAlertController.show(message: "This ingredient is being used in an instruction, you must remove the ingredient from the instruction(s) before deleting.", type: .IngredientUsedInInstruction, presenter: self)
            }
            break
        case .insert:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !readOnly && checkForInternetConnection() {
            performSegue(withIdentifier: editIngredientAlertSegueIdentifier, sender: ingredients[indexPath.row])
            ingredientBeingEdited = ingredients[indexPath.row]
            ingredientIndexBeingEdited = indexPath
            isEditingExistingIngredient = true
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return isPad ? "Ingredients" : nil
        
    }

    @IBAction func addIngredientBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func backToIngredients(segue: UIStoryboardSegue) {
        self.ingredientAlert = nil
        
        switch(segue.identifier) {
            
        case backToIngredientsIdentifier:
            guard let vc = segue.source as? IngredientAlert else { return }
            if isEditingExistingIngredient {
                isEditingExistingIngredient = false
                tableView.reloadRows(at: [ingredientIndexBeingEdited], with: .right)
                //tableView.reloadData()
                DispatchQueue.main.async {
                    if let parentVC = self.parent as? CreateRecipe {
                        if let instructionsVC = parentVC.getVC(atIndex: CreateRecipe.Controller.Instructions) as? Instructions {
                            instructionsVC.tableView.reloadData()
                        }
                    }
                }
                return
            }
            ingredients.append(vc.ingredient)
            self.tableView.reloadData()
            if isPad {
                DispatchQueue.main.async {
                    if let parentVC = self.parent as? CreateRecipe {
                        if let instructionsVC = parentVC.getVC(atIndex: CreateRecipe.Controller.Instructions) as? Instructions {
                            instructionsVC.availableIngredients = self.ingredients
                        }
                    }
                }
            }
            break;
        case cancelledEditSegueIdentifier:
            isEditingExistingIngredient = false
            break
        default:
            break;
        }
    }

    func anyInstructionContainsIngredient(atIndex: IndexPath) -> Bool {
        let ingredientToDelete = (tableView.cellForRow(at: atIndex) as! IngredientCell).ingredient
        
        if let instructions = instructions {
            return instructions.contains(where: { (i) -> Bool in
                i.ingredients.contains(where: { (ing) -> Bool in
                    if ing.toString() == ingredientToDelete?.toString() {
                        return true
                    }
                    return false
                })
            })
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        endEditing()
        if segue.identifier == ingredientAlertSegueIdentifier {
            if let alertVC = segue.destination as? IngredientAlert {
                alertVC.availableIngredients = ingredients
                alertVC.ingredientUnits = self.ingredientUnits
                self.ingredientAlert = alertVC
            }
        }
        if segue.identifier == editIngredientAlertSegueIdentifier {
            let alertVC = segue.destination as! IngredientAlert
            alertVC.availableIngredients = ingredients
            alertVC.ingredient = sender as? Ingredient
            alertVC.ingredientUnits = self.ingredientUnits
            self.ingredientAlert = alertVC
        }
    }
}
