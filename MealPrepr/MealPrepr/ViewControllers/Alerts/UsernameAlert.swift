//
//  UsernameAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/26/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit
import FirebaseAuth

private let loggedInUnwindSegueIdentifier = "loggedIn"

class UsernameAlert: MPViewController, MPTextFieldDelegate {
    
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var usernameTextField: MPTextField!
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertView.layer.cornerRadius = 16
        
        usernameTextField.authFieldType = .Username
        usernameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error trying to log user out.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccBtnClicked(_ sender: Any) {
        //Create account
        //Unwind to Login
        self.account.username = self.usernameTextField.text
        self.account.userLevel = .User
        FirebaseHelper().saveAccount(account: self.account)
        performSegue(withIdentifier: loggedInUnwindSegueIdentifier, sender: nil)
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        
    }
    
    func mpTextFieldTextDidChange(text: String?) {
        
        let errorMsg = ValidationHelper.validateUsername(username: text)
        self.usernameTextField.setError(errorMsg: errorMsg)
        
        if !self.usernameTextField.hasError {
            self.createAccountBtn.isEnabled = true
        } else {
            self.createAccountBtn.isEnabled = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
