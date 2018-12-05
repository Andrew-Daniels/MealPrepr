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
    }
    @IBAction func needAnAccountBtnClicked(_ sender: UIButton) {
    }
    @IBAction func guestBtnClicked(_ sender: UIButton) {
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        var errorKey = ValidationHelper.validateEmail(email: email)
        var errorMsg = ErrorHelper.getErrorMsg(errorKey: errorKey)
        emailTextField.setError(errorMsg: errorMsg)
        
        errorKey = ValidationHelper.validatePassword(password: password)
        errorMsg = ErrorHelper.getErrorMsg(errorKey: errorKey)
        passwordTextField.setError(errorMsg: errorMsg)
        
        if (!emailTextField.hasError && !passwordTextField.hasError) {
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error {
                    
                }
                if let u = user {
                    self.UID = u.user.uid
                }
            }
        }
    }
}

