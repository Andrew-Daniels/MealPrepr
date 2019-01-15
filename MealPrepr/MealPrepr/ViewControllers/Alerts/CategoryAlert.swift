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

class CategoryAlert: MPViewController {

    @IBOutlet weak var categoryTextField: MPTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        performSegue(withIdentifier: cancelledCategoryUnwindSegueIdentifier, sender: self)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        performSegue(withIdentifier: addCategoryUnwindSegueIdentifier, sender: self)
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
