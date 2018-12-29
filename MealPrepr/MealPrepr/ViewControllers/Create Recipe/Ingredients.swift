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
private let ingredientAlertIdentifier = "ingredientAlert"

class Ingredients: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addIngredientBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var ingredients = [Ingredient]()
    var instructions: [Instruction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier) as! IngredientCell
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle) {
            
        case .none:
            break
        case .delete:
            if (!anyInstructionContainsIngredient(atIndex: indexPath)) {
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

    @IBAction func addIngredientBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func backToIngredients(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToIngredientsIdentifier:
            guard let vc = segue.source as? IngredientAlert else { return }
            ingredients.append(vc.ingredient)
            self.tableView.reloadData()
            break;
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
        if segue.identifier == ingredientAlertIdentifier {
            if let alertVC = segue.destination as? IngredientAlert {
                alertVC.availableIngredients = ingredients
            }
        }
    }
    
}

//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//    }
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//tableView.setEditing(true, animated: false)
//tableView.allowsSelectionDuringEditing = true
//cell.showsReorderControl = true
