//
//  ViewController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

public let signUpSegueIdentifier = "SignUp"
public let registeredSegueIdentifier = "Registered"
public let loggedInSegueIdentifier = "LoggedIn"
public let homeTabBarSegueIdentifier = "HomeTabBar"
public let backToSignUpSegueIdentifier = "backToSignUp"
public let backToLoginSegueIdentifier = "backToLogin"

class Login: MPViewController, MPTextFieldDelegate {
    
    @IBOutlet weak var loginBackView: RoundedUIView!
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var passwordTextField: MPTextField!
    @IBOutlet weak var emailTextField: MPTextField!
    var handle: AuthStateDidChangeListenerHandle!
    var _FBHelper: FirebaseHelper!
    @IBOutlet var loginBackViewActiveConstraints: [NSLayoutConstraint]!
    var loginBackViewInactiveConstraints: [NSLayoutConstraint]!
    private var backViewOutOfView = false
    private var segueToSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        emailTextField.authFieldType = .Email
        passwordTextField.delegate = self
        passwordTextField.authFieldType = .Password
        _FBHelper = FirebaseHelper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(segueToSignUp) {
            performSegue(withIdentifier: signUpSegueIdentifier, sender: nil)
            segueToSignUp = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Password Reset", message: "Enter email address associated with your account", preferredStyle: .alert)
        let emailAction = UIAlertAction(title: "Send Email", style: .default) { (action) in
            if let emailTextField = alert.textFields?.first, let email = emailTextField.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
            }
        }
        emailAction.isEnabled = false
        alert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Enter Email Address"
            emailTextField.addTarget(self, action: #selector(self.emailTextFieldTextChanged(textField:)), for: .editingChanged)
            emailTextField.text = self.emailTextField.text
            if ValidationHelper.validateEmail(email: self.emailTextField.text) == nil {
                emailAction.isEnabled = true
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(emailAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func needAnAccountBtnClicked(_ sender: UIButton) {
        performSegue(withIdentifier: signUpSegueIdentifier, sender: sender)
    }
    @IBAction func guestBtnClicked(_ sender: UIButton) {
        self.account = Account()
        performSegue(withIdentifier: loggedInSegueIdentifier, sender: sender)
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        var errorMsg = ValidationHelper.validateEmail(email: email)
        emailTextField.setError(errorMsg: errorMsg)
        
        errorMsg = ValidationHelper.validatePassword(password: password)
        passwordTextField.setError(errorMsg: errorMsg)
        
        if (!emailTextField.hasError && !passwordTextField.hasError) {
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error,
                    let errorCode = AuthErrorCode(rawValue: error._code) {
                    
                    let authError = ErrorHelper.getFirebaseErrorMsg(authErrorCode: errorCode)
                    
                    self.emailTextField.setAuthError(errorMsg: authError.errorMsg, authFieldType: authError.authFieldType)
                    self.passwordTextField.setAuthError(errorMsg: authError.errorMsg, authFieldType: authError.authFieldType)
                    
                } else if let error = error {
                    
                    MPAlertController.show(message: error.localizedDescription, type: .Login, presenter: self)
                    
                }
                if let u = user {
                    //Get the username and userlevel here
                    self.account = Account(UID: u.user.uid, completionHandler: { (accountCreated) in
                        if(accountCreated) {
                            //Perform segue to homescreen here
                            self.performSegue(withIdentifier: loggedInSegueIdentifier, sender: nil)
                        }
                    })
                }
            }
        }
        else {
            self.emailTextField.notifyOfError()
            self.passwordTextField.notifyOfError()
        }
    }
    
    @objc func emailTextFieldTextChanged(textField: UITextField) {
        var resp : UIResponder! = textField
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        
        
        let email = textField.text
        let errorMsg = ValidationHelper.validateEmail(email: email)
        if (errorMsg == nil) {
            alert.actions[1].isEnabled = true
        } else if (alert.actions[1].isEnabled) {
            alert.actions[1].isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        
        if (textField == self.emailTextField) {
            let _ = self.passwordTextField.becomeFirstResponder()
        }
        else if (textField == self.passwordTextField) {
            let _ = self.passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func backToLogin(segue: UIStoryboardSegue) {
        if (backViewOutOfView) {
            backViewAnimate()
        }
    }
    
    @IBAction func backToSignUp(segue: UIStoryboardSegue) {
        self.segueToSignUp = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier) {
            
        case signUpSegueIdentifier:
            if let vc = segue.destination as? SignUp {
                vc._FBHelper = self._FBHelper
                backViewAnimate()
            }
        case loggedInSegueIdentifier:
            if let vc = segue.destination as? HomeTabBarController {
                vc.account = account
            }
        default:
            break;
        }
    }
    
    func backViewAnimate() {
        if (loginBackViewInactiveConstraints == nil) {
           loginBackViewInactiveConstraints = []
           let constraint = NSLayoutConstraint(item: loginBackView, attribute: .bottom, relatedBy: .equal, toItem: loginBackView.superview, attribute: .top, multiplier: 1.0, constant: -50.0)
            
            constraint.isActive = false
            self.view.addConstraint(constraint)
            loginBackViewInactiveConstraints.append(constraint)
        }
        let inactiveConstraints = loginBackViewInactiveConstraints
        loginBackViewInactiveConstraints.removeAll()
        
        for constraint in loginBackViewActiveConstraints {
            
            constraint.isActive = false
            loginBackViewInactiveConstraints.append(constraint)
            
        }
        
        loginBackViewActiveConstraints.removeAll()
        
        if let inactiveConstraints = inactiveConstraints {
            for constraint in inactiveConstraints {
                
                constraint.isActive = true
                loginBackViewActiveConstraints.append(constraint)
                
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        backViewOutOfView = !backViewOutOfView
    }
}

