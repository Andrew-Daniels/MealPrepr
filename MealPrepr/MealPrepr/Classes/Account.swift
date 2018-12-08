//
//  Account.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

struct Account {
    
    public enum UserLevel: Int {
        case Admin = 1
        case User = 0
        case Guest = -1
    }
    
    var UID: String?
    var username: String?
    var userLevel: UserLevel = .Guest
    
    private var _userLevel: Int? {
        didSet {
            if let level = _userLevel, let ul = UserLevel(rawValue: level) {
                userLevel = ul
            }
        }
    }
    
    init() {
        
    }
    
    init(UID: String?, username: String?, userLevel: Int?) {
        self.UID = UID
        self.username = username
        self._userLevel = userLevel
    }
}
