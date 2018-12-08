//
//  Account.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

struct Account {
    
    var UID: String?
    var username: String?
    var userLevel: Int?
    
    init() {
        
    }
    
    init(UID: String?, username: String?, userLevel: Int?) {
        self.UID = UID
        self.username = username
        self.userLevel = userLevel
    }
}
