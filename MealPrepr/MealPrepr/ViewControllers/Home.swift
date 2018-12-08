//
//  Home.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class Home: MPViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if(account.userLevel == .Guest) {
            let createAccountBtn = UIBarButtonItem(title: "Create Account", style: .done, target: self, action: #selector(createAccountBtnClicked))
            self.navigationItem.leftBarButtonItem = createAccountBtn
        } else {
            let logoutBtn = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutBtnClicked))
            self.navigationItem.rightBarButtonItem = logoutBtn
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func createAccountBtnClicked() {
        performSegue(withIdentifier: backToSignUpSegueIdentifier, sender: nil)
    }
    @objc func logoutBtnClicked() {
        performSegue(withIdentifier: backToLoginSegueIdentifier, sender: nil)
    }
}
