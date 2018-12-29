//
//  Utensils.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let utensilCellIdentifier = "UtensilCell"
public let backToUtensilsIdentifier = "backToUtensils"
private let editUtensilAlertSegueIdentifier = "editUtensil"
private let utensilAlertSegueIdentifier = "UtensilAlert"
private let cancelledEditSegueIdentifier = "cancelledEdit"

class Utensils: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    var utensils = [String]()
    @IBOutlet weak var tableView: UITableView!
    var utensilIndexBeingEdited: IndexPath!
    var isEditingExistingUtensil = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utensils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: utensilCellIdentifier) as! UtensilCell
        cell.utensil = utensils[indexPath.row]
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
            utensils.remove(at: indexPath.row)
            tableView.reloadData()
            break
        case .insert:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: editUtensilAlertSegueIdentifier, sender: utensils[indexPath.row])
        utensilIndexBeingEdited = indexPath
        isEditingExistingUtensil = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func backToUtensils(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToUtensilsIdentifier:
            guard let vc = segue.source as? UtensilAlert else { return }
            if isEditingExistingUtensil {
                utensils[utensilIndexBeingEdited.row] = vc.utensil
                isEditingExistingUtensil = false
                tableView.reloadRows(at: [utensilIndexBeingEdited], with: .right)
                return
            }
            utensils.append(vc.utensil)
            self.tableView.reloadData()
            break
        case cancelledEditSegueIdentifier:
            isEditingExistingUtensil = false
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == utensilAlertSegueIdentifier {
            if let alertVC = segue.destination as? UtensilAlert {
                alertVC.availableUtensils = utensils
            }
        }
        if segue.identifier == editUtensilAlertSegueIdentifier {
            if let alertVC = segue.destination as? UtensilAlert {
                alertVC.availableUtensils = utensils
                alertVC.utensil = sender as? String
            }
        }
    }
}
