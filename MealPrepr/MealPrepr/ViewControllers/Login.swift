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
import FBSDKLoginKit
import FBSDKCoreKit

public let signUpSegueIdentifier = "SignUp"
public let registeredSegueIdentifier = "Registered"
public let loggedInSegueIdentifier = "LoggedIn"
public let homeTabBarSegueIdentifier = "HomeTabBar"
public let backToSignUpSegueIdentifier = "backToSignUp"
public let backToLoginSegueIdentifier = "backToLogin"
public let createRecipeSegueIdentifier = "CreateRecipe"
private let usernameAlertSegueIdentifier = "usernameAlert"

class Login: MPViewController, MPTextFieldDelegate, FBSDKLoginButtonDelegate {
    
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
    @IBOutlet weak var fbLoginBtn: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        emailTextField.authFieldType = .Email
        passwordTextField.delegate = self
        passwordTextField.authFieldType = .Password
        
        _FBHelper = FirebaseHelper()
        
        fbLoginBtn.delegate = self
        fbLoginBtn.readPermissions = ["public_profile", "email"]
        
        handleAuthToken()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        handleAuthToken()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error trying to log user out.")
        }
    }
    
    private func handleAuthToken() {
        if let token = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                //User is signed in
                if let user = authResult?.user {
                    self.handleUser(user: user, isFBAuth: true)
                }
            }
        } else if let user = Auth.auth().currentUser {
            //User is signed in
            handleUser(user: user)
        }
    }
    
    private func handleUser(user: User, isFBAuth: Bool = false) {
        self.account = Account(UID: user.uid, completionHandler: { (actCreated) in
            self.account.isFBAuth = isFBAuth
            if actCreated {
                //perform segue to homepage
                self.performSegue(withIdentifier: loggedInSegueIdentifier, sender: nil)
            } else {
                //Request username to create a new account
                //then perform segue to homepage
                self.performSegue(withIdentifier: usernameAlertSegueIdentifier, sender: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        //self.account.userLevel = .Admin
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
    
    @IBAction func backToLoginLoggedIn(segue: UIStoryboardSegue) {
        //Perform segue to homescreen here
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.performSegue(withIdentifier: loggedInSegueIdentifier, sender: nil)
        }
    }
    
    @IBAction func backToSignUp(segue: UIStoryboardSegue) {
        self.segueToSignUp = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier) {
            
        case signUpSegueIdentifier:
            if let vc = segue.destination as? SignUp {
                vc.email = self.emailTextField.text
                backViewAnimate()
            }
        default:
            break;
        }
    }
    
    func backViewAnimate() {
        if (loginBackViewInactiveConstraints == nil) {
           loginBackViewInactiveConstraints = []
           let constraint = NSLayoutConstraint(item: loginBackView, attribute: .bottom, relatedBy: .equal, toItem: loginBackView.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
            
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
        
        backViewOutOfView = !backViewOutOfView
        
        UIView.animate(withDuration: 0.4) {
            if (self.backViewOutOfView) {
                self.guestBtn.isHidden = true
                self.fbLoginBtn.isHidden = true
            } else {
                self.guestBtn.isHidden = false
                self.fbLoginBtn.isHidden = false
            }
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func fbLoginBtnClicked(_ sender: Any) {
        
    }
}

