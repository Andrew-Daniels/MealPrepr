//
//  MPTabBarController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class MPTabBarController: UITabBarController {

    var account: Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let controllers = self.viewControllers {
            for controller in controllers {
                if let navController = controller as? MPNavigationController {
                    navController.account = account
                }
            }
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

}
