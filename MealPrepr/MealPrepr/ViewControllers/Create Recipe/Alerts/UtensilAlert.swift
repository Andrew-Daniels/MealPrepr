//
//  UtensilAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class UtensilAlert: MPViewController, MPTextFieldDelegate {
    
    @IBOutlet weak var utensilTextField: MPTextField!
    var utensil: String!
    var availableUtensils: [String]!
    var isEditingExistingUtensil = false
    var originalTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utensilTextField.delegate = self
        let _ = utensilTextField.becomeFirstResponder()
        
        setupAlertWithUtensil()
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let utensil = utensilTextField.text
        
        let errorMsg = ValidationHelper.validateUtensilTitle(utensilTitle: utensil, availableUtensils: availableUtensils, excludingTitle: originalTitle)
        utensilTextField.setError(errorMsg: errorMsg)
        
        if utensilTextField.hasError {
            //DONT Transition
            return
        }
        self.utensil = utensil
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToUtensilsIdentifier, sender: self)
        
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        let _ = textField.resignFirstResponder()
    }
    
    func setupAlertWithUtensil() {
        if utensil != nil {
            isEditingExistingUtensil = true
            utensilTextField.text = utensil
            originalTitle = utensil
        }
    }
}

