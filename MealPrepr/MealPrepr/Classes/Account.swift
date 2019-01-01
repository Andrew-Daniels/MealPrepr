//
//  Account.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

class Account {
    
    public enum UserLevel: Int {
        case Admin = 1
        case User = 0
        case Guest = -1
    }
    
    var UID: String?
    var username: String?
    var userLevel: UserLevel = .Guest
    
    init() {
        
    }
    
    init(UID: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        FirebaseHelper().retrieveAccountInfo(UID: UID) { (accountInfo) in
            self.UID = UID
            self.username = accountInfo.username
            if let level = accountInfo.userLevel, let ul = UserLevel(rawValue: level) {
                self.userLevel = ul
            }
            completionHandler(true)
        }
    }
    
    init(UID: String?, username: String?, userLevel: Int?) {
        self.UID = UID
        self.username = username
        if let level = userLevel, let ul = UserLevel(rawValue: level) {
            self.userLevel = ul
        }
    }
    
    init(UID: String?, username: String?, userLevel: UserLevel?) {
        self.UID = UID
        self.username = username
        if let level = userLevel {
            self.userLevel = level
        }
    }
}
