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

class Utensils: MPViewController {
    
    var utensils = [String]()
    @IBOutlet weak var tableView: UITableView!
    var utensilIndexBeingEdited: IndexPath!
    var isEditingExistingUtensil = false
    var availableUtensils = [Utensil]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper().loadUtensils { (utensils) in
            self.availableUtensils = utensils
        }
    }
    
    @IBAction func backToUtensils(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToUtensilsIdentifier:
            guard let vc = segue.source as? UtensilAlert else { return }
            break
        case cancelledEditSegueIdentifier:
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == utensilAlertSegueIdentifier {
            if let alertVC = segue.destination as? UtensilAlert {
                alertVC.availableUtensils = availableUtensils
            }
        }
        if segue.identifier == editUtensilAlertSegueIdentifier {
            if let alertVC = segue.destination as? UtensilAlert {
                alertVC.availableUtensils = availableUtensils
            }
        }
    }
}
