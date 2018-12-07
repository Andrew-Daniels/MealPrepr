//
//  SignUp.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/6/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class SignUp: UIViewController, MPTextFieldDelegate {

    @IBOutlet weak var emailTextField: MPTextField!
    @IBOutlet weak var usernameTextField: MPTextField!
    @IBOutlet weak var passwordTextField: MPTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let email = emailTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        var errorMsg = ValidationHelper.validateEmail(email: email)
        emailTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.validatePassword(password: password)
        passwordTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.validateUsername(username: username)
        usernameTextField.setError(errorMsg: errorMsg)
        
        if (!emailTextField.hasError && !passwordTextField.hasError && !usernameTextField.hasError) {
            //Try to create the account
        }
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if (textField == self.emailTextField) {
            let _ = self.usernameTextField.becomeFirstResponder()
        }
        else if (textField == self.usernameTextField) {
            let _ = self.passwordTextField.becomeFirstResponder()
        }
        else if (textField == self.passwordTextField) {
            let _ = self.passwordTextField.resignFirstResponder()
        }
    }
}
