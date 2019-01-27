//
//  CreateRecipeChildController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/12/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

private let readOnlyConstraintIdentifier = "readOnly"
private let createOnlyConstraintIdentifier = "createOnly"

class MPCreateRecipeChildController: MPViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet var constraints: [NSLayoutConstraint]!
    var readOnly: Bool = false
    var isEditingExistingRecipe: Bool = false
    var readOnlyConstraintsSet = false
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateConstraints()
    }
    
    private func updateConstraints() {
        if readOnly && !readOnlyConstraintsSet {
            
            editBtn?.isHidden = true
            addBtn.isHidden = true
            addBtn.isEnabled = false
            
            for c in constraints {
                if c.identifier == createOnlyConstraintIdentifier {
                    c.isActive = false
                }
            }
            
            for c in constraints {
                if c.identifier == readOnlyConstraintIdentifier {
                    c.isActive = true
                }
            }
            
            self.view.layoutIfNeeded()
            
            readOnlyConstraintsSet = true
            
        }
    }
    
    override func endEditing() {
        if let parent = self.parent as? MPViewController {
            parent.endEditing()
        }
    }
    @IBAction func editBtnClicked(_ sender: Any) {
        if let t = self.tableView {
            t.setEditing(true, animated: true)
            doneBtn.isHidden = false
            editBtn.isHidden = true
        }
    }
    @IBAction func doneBtnClicked(_ sender: Any) {
        if let t = self.tableView {
            t.setEditing(false, animated: true)
            doneBtn.isHidden = true
            editBtn.isHidden = false
        }
    }
    
    public func tableViewModelDidChange(modelCount: Int) {
        
        if !readOnly && modelCount > 0 && !self.tableView.isEditing && self.editBtn.isHidden {
            self.editBtn.isHidden = false
            return
        }
        
        if !readOnly && modelCount == 0 {
            self.editBtn.isHidden = true
            self.doneBtn.isHidden = true
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
                self.tableView.setEditing(false, animated: false)
            }
        }
    }
}
