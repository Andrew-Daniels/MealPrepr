//
//  SignUp.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/6/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUp: MPViewController, MPTextFieldDelegate {
    
    @IBOutlet weak var emailTextField: MPTextField!
    @IBOutlet weak var usernameTextField: MPTextField!
    @IBOutlet weak var passwordTextField: MPTextField!
    var _FBHelper: FirebaseHelper!
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        emailTextField.authFieldType = .Email
        emailTextField.text = email
        usernameTextField.delegate = self
        usernameTextField.authFieldType = .Username
        passwordTextField.delegate = self
        passwordTextField.authFieldType = .Password
        _FBHelper = FirebaseHelper()
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        
        if !checkForInternetConnection() {
            return
        }
        
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
            //self.startLoading(withText: "Creating account")
            self.startLoading(withText: "Creating account") { (shown) in
                if shown {
                    Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                        if let error = error,
                            let errorCode = AuthErrorCode(rawValue: error._code) {
                            
                            let authError = ErrorHelper.getFirebaseErrorMsg(authErrorCode: errorCode)
                            
                            self.emailTextField.setAuthError(errorMsg: authError.errorMsg, authFieldType: authError.authFieldType)
                            self.passwordTextField.setAuthError(errorMsg: authError.errorMsg, authFieldType: authError.authFieldType)
                            self.finishLoadingWithError(completionHandler: { (finished) in
                                
                            })
                        } else if let error = error {
                            
                            self.finishLoading(completionHandler: { (finished) in
                                if finished {
                                    MPAlertController.show(message: error.localizedDescription, type: .SignUp, presenter: self)
                                    
                                }
                            })
                        }
                        guard let user = authResult?.user else { return }
                        
                        self.finishLoading(completionHandler: { (finished) in
                            if finished {
                                self.account = Account(UID: user.uid, username: username, userLevel: .User)
                                self.account.email = user.email
                                self._FBHelper.saveAccount(account: self.account)
                                self.performSegue(withIdentifier: registeredSegueIdentifier, sender: nil)
                            }
                        })
                    }
                }
            }
            
        }
        else {
            self.finishLoading { (finished) in
                if finished {
                    self.emailTextField.notifyOfError()
                    self.passwordTextField.notifyOfError()
                    self.usernameTextField.notifyOfError()
                }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        connectionErrorView?.stopNotifier()
    }
}
