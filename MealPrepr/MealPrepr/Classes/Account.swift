//
//  Account.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

let allCategoriesString = "All Saved Recipes"

import Foundation
import FirebaseAuth
import Firebase
import UIKit

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
    var dateJoined: Date?
    private var profilePicture: UIImage?
    
    init() {
        
    }
    
    init(UID: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        FirebaseHelper().retrieveAccountInfo(UID: UID) { (accountInfo) in
            self.UID = UID
            self.username = accountInfo.username
            self.dateJoined = accountInfo.dateJoined
            
            if let level = accountInfo.userLevel, let ul = UserLevel(rawValue: level) {
                self.userLevel = ul
                FirebaseHelper().loadCategories(account: self)
                completionHandler(true)
                return
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
    
    func getProfilePicture(completionHandler: @escaping (_ isResponse : UIImage) -> Void) {
        if let p = profilePicture {
            completionHandler(p)
            return
        }
        if let UID = UID {
        let path = "ProfilePictures/\(UID)"
            FirebaseHelper().downloadImage(atPath: path, renderMode: .alwaysOriginal) { (image) in
                self.profilePicture = image
                completionHandler(image)
            }
        }
    }
    
    func setProfilePicture(image: UIImage) {
        self.profilePicture = image
        //Save image to account
    }
    
    private func reauthenticateUser(currentPassword: String, completionHandler: @escaping (_ isResponse : User) -> Void) {
        let user = Auth.auth().currentUser
        if let u = user {
            let cred = EmailAuthProvider.credential(withEmail:u.email!, password: currentPassword);
            user?.reauthenticateAndRetrieveData(with: cred, completion: { (authDataResult, error) in
                if let authenticated = authDataResult {
                    completionHandler(authenticated.user)
                }
            })
        }
    }
    
    func changePassword(fromPassword: String, toPassword: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        reauthenticateUser(currentPassword: fromPassword) { (user) in
            user.updatePassword(to: toPassword, completion: { (error) in
                if let error = error {
                    print(error)
                    completionHandler(false)
                    return
                } else {
                    completionHandler(true)
                }
            })
        }
    }
    
    func changeEmail(password: String, toEmail: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        reauthenticateUser(currentPassword: password) { (user) in
            user.updateEmail(to: toEmail, completion: { (error) in
                if let error = error {
                    print(error)
                    completionHandler(false)
                    return
                } else {
                    completionHandler(true)
                }
            })
        }
    }
    
    func changeUsername(password: String, toUsername: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        reauthenticateUser(currentPassword: password) { (user) in
            if let UID = self.UID {
                let path = "Accounts/\(UID)/Username"
                let database = Database.database().reference()
                
                database.child(path).setValue(toUsername)
                completionHandler(true)
            }
            completionHandler(false)
        }
    }
}
