//
//  Account.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

let allCategoriesString = "All Saved Recipes"

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
    var recipeCategories = [String]()
    
    init() {
        
    }
    
    init(UID: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        FirebaseHelper().retrieveAccountInfo(UID: UID) { (accountInfo) in
            self.UID = UID
            self.username = accountInfo.username
            if let level = accountInfo.userLevel, let ul = UserLevel(rawValue: level) {
                self.userLevel = ul
                FirebaseHelper().loadCategories(account: self)
                completionHandler(true)
            }
            completionHandler(false)
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
    
    func savingCategories() {
        self.recipeCategories.removeAll { (string) -> Bool in
            if string == "Favorites" || string == allCategoriesString {
                return true
            }
            return false
        }
    }
    
    func savedCategories() {
        if !self.recipeCategories.contains("Favorites") {
            self.recipeCategories.insert("Favorites", at: 0)
            self.recipeCategories.insert(allCategoriesString, at: 0)
        }
    }
    
    func viewingCategories() {
        self.recipeCategories.removeAll { (string) -> Bool in
            if string == allCategoriesString {
                return true
            }
            return false
        }
    }
    
    func finishedViewingCategories() {
        if !self.recipeCategories.contains(allCategoriesString) {
            self.recipeCategories.insert(allCategoriesString, at: 0)
        }
    }
}
