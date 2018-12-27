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
let backToInstructionsSegueIdentifier = "backToInstructions"

class Instructions: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var availableIngredients = [Ingredient]()
    var instructions = [Instruction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addInstructionBtnClicked(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: instructionCellIdentifier, for: indexPath) as! InstructionCell
        cell.instruction = instructions[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == instructionAlertSegueIdentifier {
            let alert = segue.destination as! InstructionAlert
            alert.hidesBottomBarWhenPushed = true
            alert.availableIngredients = availableIngredients
        }
    }
    
    @IBAction func backToInstructions(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToInstructionsSegueIdentifier:
            guard let vc = segue.source as? InstructionAlert else { return }
            instructions.append(vc.instruction)
            tableView.reloadData()
            break;
        default:
            break;
        }
    }
    
}
