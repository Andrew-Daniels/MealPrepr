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
    }
    
    public static func show(title: String, message: String, type: AlertType, viewController: UIViewController) {
        var actionTitle: String!
        let actionStyle: UIAlertActionStyle = .cancel
        
        switch(type) {
            
        case .Standard:
            actionTitle = "OK"
        case .Login:
            actionTitle = "Try Again"
        case .SignUp:
            actionTitle = "Try Again"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
