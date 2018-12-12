//
//  HomeTabBarController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class HomeTabBarController: MPTabBarController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if account.userLevel != .Admin {
            let adminController = self.viewControllers?.first(where: { (viewController) -> Bool in
                if (viewController is AdminNavigationViewController) {
                    return true
                }
                return false
            })

            guard let controller = adminController else { return }
            guard let index = self.viewControllers?.index(of: controller) else { return }
            self.viewControllers?.remove(at: index)
        }
    }

}
