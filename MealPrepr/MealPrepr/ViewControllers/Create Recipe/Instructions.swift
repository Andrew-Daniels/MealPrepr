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

class Instructions: MPViewController, UITableViewDelegate, UITableViewDataSource, InstructionCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var availableIngredients = [Ingredient]()
    var instructions = [Instruction]()
    var isEditingExistingInstruction = false
    var instructionBeingEdited: Instruction!
    var instructionIndexBeingEdited: IndexPath!
    var collectionViewCellSizeAtIndexPath = [IndexPath : CGSize]()
    
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
        cell.delegate = self
        if let collectionViewCellHeight = collectionViewCellSizeAtIndexPath[indexPath]?.height {
            cell.knownCellHeight = collectionViewCellHeight
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: editInstructionAlertSegueIdentifier, sender: instructions[indexPath.row])
        instructionBeingEdited = instructions[indexPath.row]
        instructionIndexBeingEdited = indexPath
        isEditingExistingInstruction = true
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    func instructionCellCollectionViewContentSizeSet(for cell: InstructionCell, toSize: CGSize) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        collectionViewCellSizeAtIndexPath[indexPath] = toSize
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionViewCellSizeAtIndexPath = [IndexPath : CGSize]()
    }
}
