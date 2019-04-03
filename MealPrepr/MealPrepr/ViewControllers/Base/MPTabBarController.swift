//
//  MPTabBarController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class MPTabBarController: UITabBarController, ConnectionErrorViewDelegate {

    var account: AccountModel!
    private var defaultTabBarOrigin: CGPoint!
    var connectionErrorView: ConnectionErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTabBarOrigin = self.view.bounds.origin
        if let controllers = self.viewControllers {
            for controller in controllers {
                if let navController = controller as? MPNavigationController {
                    navController.account = account
                }
            }
        }
        connectionErrorView = ConnectionErrorView(parent: self, bottomViewConstant: 50.0)
    }
    
    
    private func setTabBarOrigin(slideUp: Bool) {
        
        DispatchQueue.main.async {
            if slideUp {
                let tabBarOrigin = CGPoint(x: self.defaultTabBarOrigin.x, y: self.defaultTabBarOrigin.y + 50)
                self.view.bounds.origin = tabBarOrigin
            } else {
                self.view.bounds.origin = self.defaultTabBarOrigin
            }
        }
        
    }

    func handleErrorViewVisibility(visible: Bool) {
        setTabBarOrigin(slideUp: visible)
    }

}
