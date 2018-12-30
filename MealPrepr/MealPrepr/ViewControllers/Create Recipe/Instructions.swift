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
        cell.delegate = self
        if let collectionViewCellHeight = collectionViewContentSizeAtIndexPath[indexPath]?.height {
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
        if let _ = instructionIndexBeingEdited {
            if collectionViewContentSizeAtIndexPath[instructionIndexBeingEdited] != toSize {
                collectionViewContentSizeAtIndexPath[instructionIndexBeingEdited] = toSize
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [self.instructionIndexBeingEdited], with: .fade)
                }
            }
        }
        else {
            let indexPath = IndexPath(row: instructions.count - 1, section: 0)
            if collectionViewContentSizeAtIndexPath[indexPath] != toSize {
                collectionViewContentSizeAtIndexPath[indexPath] = toSize
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        //guard let _ = tableView.cellForRow(at: instructionIndexBeingEdited) else { return }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionViewContentSizeAtIndexPath = [IndexPath : CGSize]()
    }
}
