//
//  Instructions.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let instructionAlertSegueIdentifier = "InstructionAlert"
private let instructionCellIdentifier = "InstructionCell"
private let editInstructionAlertSegueIdentifier = "EditInstruction"
let backToInstructionsSegueIdentifier = "backToInstructions"
private let ingredientAlertSegueIdentifier = "ingredientAlert"

class Instructions: MPCreateRecipeChildController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var availableIngredients = [Ingredient]()
    var instructions = [Instruction]()
    var isEditingExistingInstruction = false
    var instructionBeingEdited: Instruction!
    var instructionIndexBeingEdited: IndexPath!
    var collectionViewContentSizeAtIndexPath = [IndexPath : CGSize]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    @IBAction func addInstructionBtnClicked(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: instructionCellIdentifier, for: indexPath) as! InstructionCell
        let instruction = instructions[indexPath.row]
        cell.instruction = instruction
        cell.instructionLabel.text = instruction.instruction
        cell.frame = tableView.bounds;
        cell.layoutIfNeeded()
        
        cell.collectionViewHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height;
        
        if readOnly {
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !readOnly {
            performSegue(withIdentifier: editInstructionAlertSegueIdentifier, sender: instructions[indexPath.row])
            instructionBeingEdited = instructions[indexPath.row]
            instructionIndexBeingEdited = indexPath
            isEditingExistingInstruction = true
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !readOnly
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.instructions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endEditing()
        super.prepare(for: segue, sender: sender)
        if segue.identifier == instructionAlertSegueIdentifier {
            let alert = segue.destination as! InstructionAlert
            alert.hidesBottomBarWhenPushed = true
            alert.availableIngredients = availableIngredients
        }
        if segue.identifier == editInstructionAlertSegueIdentifier {
            let alert = segue.destination as! InstructionAlert
            alert.hidesBottomBarWhenPushed = true
            alert.availableIngredients = availableIngredients
            alert.instruction = sender as? Instruction
        }
    }
    
    @IBAction func backToInstructions(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToInstructionsSegueIdentifier:
            guard let vc = segue.source as? InstructionAlert else { return }
            if isEditingExistingInstruction {
                if let instruction = vc.instruction {
                    instructionBeingEdited.instruction = instruction.instruction
                    instructionBeingEdited.ingredients = instruction.ingredients
                    instructionBeingEdited.timeInMinutes = instruction.timeInMinutes
                    instructionBeingEdited.type = instruction.type
                }
                isEditingExistingInstruction = false
                tableView.reloadRows(at: [instructionIndexBeingEdited], with: .right)
                return
            }
            instructions.append(vc.instruction)
            tableView.reloadData()
            break;
        default:
            break;
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
    }
}
