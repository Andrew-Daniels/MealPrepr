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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utensilTextField.delegate = self
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let utensil = utensilTextField.text
        
        let errorMsg = ValidationHelper.checkIfEmpty(text: utensil)
        utensilTextField.setError(errorMsg: errorMsg)
        
        if utensilTextField.hasError {
            //DONT Transition
            return
        }
        
        self.utensil = utensil
        
        performSegue(withIdentifier: backToUtensilsIdentifier, sender: self)
        
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        let _ = textField.resignFirstResponder()
    }
}

