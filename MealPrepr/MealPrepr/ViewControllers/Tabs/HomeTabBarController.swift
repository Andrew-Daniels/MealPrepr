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
    
    enum Controller: Int {
        case Home
        case Categories
        case Weekplan
        case Settings
    }
    
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

    public func getVC(controller: Controller) -> MPNavigationController? {
        
        guard let viewControllers = self.viewControllers else { return nil }
        
        switch controller {
            
        case .Home:
            for vc in viewControllers {
                if vc is HomeNavigationController {
                    return vc as? HomeNavigationController
                }
            }
        case .Categories:
            for vc in viewControllers {
                if vc is CategoriesNavigationController {
                    return vc as? CategoriesNavigationController
                }
            }
        case .Weekplan:
            break;
        case .Settings:
            break;
        }
        
        return nil
    }
    
}
