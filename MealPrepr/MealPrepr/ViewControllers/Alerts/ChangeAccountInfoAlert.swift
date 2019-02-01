//
//  ChangeAccountInfoAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/30/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class ChangeAccountInfoAlert: MPViewController, MPTextFieldDelegate {
    
    enum ChangeType: Int {
        case Email
        case Username
        case Password
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var passwordTextField: MPTextField!
    @IBOutlet weak var otherTextField: MPTextField!
    @IBOutlet weak var changeBtn: UIButton!
    
    
    var changeType: ChangeType?
    var requiresCurrentPassword: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let c = changeType {
            setupAlert(with: c)
        }
        
        
        passwordTextField.delegate = self
        otherTextField.delegate = self
        
        if !requiresCurrentPassword {
            passwordTextField.isHidden = true
            let _ = otherTextField.becomeFirstResponder()
        } else {
           let _ = self.passwordTextField.becomeFirstResponder()
        }
    }
    
    func setupAlert(with changeType: ChangeType) {
        
        self.changeType = changeType
        
        switch changeType {
            
        case .Email:
            label.text = "Change Email"
            passwordTextField.placeholderText = "Current Password"
            otherTextField.placeholderText = "New Email Address"
        case .Username:
            label.text = "Change Username"
            passwordTextField.placeholderText = "Current Password"
            otherTextField.placeholderText = "New Username"
            otherTextField.authFieldType = .Username
        case .Password:
            label.text = "Change Password"
            otherTextField.placeholderText = "New Password"
            otherTextField.passwordField = true
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.endEditing()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeBtnClicked(_ sender: Any) {
        if let type = self.changeType {
            
            var errorMsg: String? = nil
            
            if requiresCurrentPassword {
                errorMsg = ValidationHelper.validatePassword(password: passwordTextField.text)
                passwordTextField.setError(errorMsg: errorMsg)
            }
            
            switch type {
                
            case .Email:
                errorMsg = ValidationHelper.validateEmail(email: otherTextField.text)
                otherTextField.setError(errorMsg: errorMsg)
                break
            case .Username:
                errorMsg = ValidationHelper.validateUsername(username: otherTextField.text)
                otherTextField.setError(errorMsg: errorMsg)
                break
            case .Password:
                errorMsg = ValidationHelper.validatePassword(password: otherTextField.text)
                otherTextField.setError(errorMsg: errorMsg)
                break
            }
            
            if !otherTextField.hasError && !passwordTextField.hasError {
                //Do stuff
                switch type {
                    
                case .Email:
                    self.account.changeEmail(password: passwordTextField.text!, toEmail: otherTextField.text!) { (success) in
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.passwordTextField.setError(errorMsg: "Password entered isn't correct.")
                        }
                    }
                case .Username:
                    self.account.changeUsername(password: passwordTextField.text!, toUsername: otherTextField.text!) { (success) in
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.passwordTextField.setError(errorMsg: "Password entered isn't correct.")
                        }
                    }
                case .Password:
                    self.account.changePassword(fromPassword: passwordTextField.text!, toPassword: otherTextField.text!) { (success) in
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.passwordTextField.setError(errorMsg: "Password entered isn't correct.")
                        }
                    }
                }
            } else {
                passwordTextField.notifyOfError()
                otherTextField.notifyOfError()
            }
            
        }
        
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if textField == passwordTextField {
            let _ = otherTextField.becomeFirstResponder()
        } else if textField == otherTextField {
            let _ = otherTextField.resignFirstResponder()
        }
    }
    
    override func endEditing() {
        super.endEditing()
        let _ = passwordTextField.resignFirstResponder()
        let _ = otherTextField.resignFirstResponder()
    }

}
