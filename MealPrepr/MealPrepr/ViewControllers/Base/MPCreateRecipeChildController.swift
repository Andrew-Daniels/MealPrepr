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
private let bottomConstraintIdentifier = "bottomConstraint"

class MPCreateRecipeChildController: MPViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet var constraints: [NSLayoutConstraint]!
    var readOnly: Bool = false
    var readOnlyConstraintsSet = false
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateConstraints()
    }
    
    private func updateConstraints() {
        if readOnly && !readOnlyConstraintsSet {
            
            addBtn.isHidden = true
            addBtn.isEnabled = false
            
            for c in constraints {
                switch (c.identifier) {
                case readOnlyConstraintIdentifier:
                    c.isActive = true
                    break
                case createOnlyConstraintIdentifier:
                    c.isActive = false
                    break
                case bottomConstraintIdentifier:
                    c.constant = 0
                default:
                    break
                }
                
                self.view.layoutIfNeeded()
            }
            
            readOnlyConstraintsSet = true
            
        }
    }
    
    override func endEditing() {
        if let parent = self.parent as? MPViewController {
            parent.endEditing()
        }
    }
}
