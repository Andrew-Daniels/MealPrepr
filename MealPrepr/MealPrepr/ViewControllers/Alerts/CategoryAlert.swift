//
//  CategoryAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/14/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

let cancelledCategoryUnwindSegueIdentifier = "cancelledCategory"
let addCategoryUnwindSegueIdentifier = "addCategory"

class CategoryAlert: MPViewController, MPTextFieldDelegate {
    
    @IBOutlet weak var categoryTextField: MPTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        let _ = categoryTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        performSegue(withIdentifier: cancelledCategoryUnwindSegueIdentifier, sender: self)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let errorMsg = ValidationHelper.validateCategory(account: self.account, category: categoryTextField.text)
        categoryTextField.setError(errorMsg: errorMsg)
        
        if !categoryTextField.hasError {
            self.view.endEditing(true)
            self.account.recipeCategories.append(categoryTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            FirebaseHelper().saveCategory(account: self.account)
            performSegue(withIdentifier: addCategoryUnwindSegueIdentifier, sender: self)
        }
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        let _ = self.categoryTextField.resignFirstResponder()
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
