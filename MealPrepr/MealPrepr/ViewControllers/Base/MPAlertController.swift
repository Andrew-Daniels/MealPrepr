//
//  MPAlertDialog.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/6/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class MPAlertController {
    
    public enum AlertType {
        case Standard
        case Login
        case SignUp
        case CreateAccount
        case IngredientUsedInInstruction
    }
    
    public static func show(message: String, type: AlertType, presenter: UIViewController) {
        let alert = self.create(message: message, type: type, presenter: presenter)
        presenter.present(alert, animated: true, completion: nil)
    }
    
    public static func create(message: String, type: AlertType, presenter: UIViewController) -> UIAlertController {
        var actionTitle: String!
        var title: String!
        switch(type) {
            
        case .Standard:
            title = "Uh oh"
            actionTitle = "OK"
        case .Login:
            title = "Login Error"
            actionTitle = "Try Again"
        case .SignUp:
            title = "Register Error"
            actionTitle = "Try Again"
        case .CreateAccount:
            title = "Account Required"
            actionTitle = "Create an Account"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                if let vc = presenter as? MPViewController {
                    if let tabVC = vc.tabBarController, tabVC.selectedIndex != 0 {
                        tabVC.selectedIndex = 0
                    }
                }
            }
            let createAccountAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
                if let vc = presenter as? MPViewController {
                    vc.createAccountBtnClicked()
                }
            }
            alert.addAction(action)
            alert.addAction(createAccountAction)
            return alert
        case .IngredientUsedInInstruction:
            title = "Cannot Delete Ingredient"
            actionTitle = "Edit Instructions"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let editInstructionsAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
                if let vc = presenter as? Ingredients, let parentVC = vc.parent as? CreateRecipe {
                    parentVC.presentVC(atIndex: CreateRecipe.Controller.Instructions)
                }
            }
            alert.addAction(action)
            alert.addAction(editInstructionsAction)
            return alert
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
}
