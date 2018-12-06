//
//  ViewController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginBackView: RoundedUIView!
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var passwordTextField: MPTextField!
    @IBOutlet weak var emailTextField: MPTextField!
    var handle: AuthStateDidChangeListenerHandle!

    var UID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let email = "skaterphreak@gmail.com"
//        let password = "123456"
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            guard let _ = authResult?.user else { return }
//        }
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
        alert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Enter Email Address"
            emailTextField.addTarget(self, action: #selector(self.emailTextFieldTextChanged(textField:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        emailAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(emailAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func needAnAccountBtnClicked(_ sender: UIButton) {
    }
    @IBAction func guestBtnClicked(_ sender: UIButton) {
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
                if let error = error {
                    let alert = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                if let u = user {
                    self.UID = u.user.uid
                    //Perform segue to homescreen here
                }
            }
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
}

