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
    
    public enum UserLevel: Int, Codable {
        case Admin = 1
        case User = 0
        case Guest = -1
    }
    
    var UID: String?
    var username: String?
    var email: String?
    var userLevel: UserLevel = .Guest
    var recipeCategories = [String]()
    var dateJoined: Date?
    var isFBAuth: Bool = false
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
    
    convenience init(UID: String, accountDelegate: AccountDelegate?) {
        self.init(UID: UID) { (completed) in
            accountDelegate?.accountLoaded()
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
    
    func getProfilePicture(completionHandler: @escaping (_ isResponse : UIImage?) -> Void) {
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
        if let data = image.pngData(), let UID = self.UID {
            let storage = Storage.storage().reference()
        
            let path = "ProfilePictures/\(UID)"
            let photoRef = storage.child(path)
            photoRef.putData(data, metadata: nil) { (metadata, error) in
                guard let _ = metadata else {
                // Uh-oh, an error occurred!
                return
                }
            }
        }
    }
    
    private func reauthenticateUser(currentPassword: String, completionHandler: @escaping (_ isResponse : User?) -> Void) {
        let user = Auth.auth().currentUser
        if let u = user {
            let cred = EmailAuthProvider.credential(withEmail:u.email!, password: currentPassword);
            u.reauthenticateAndRetrieveData(with: cred, completion: { (authDataResult, error) in
                if let error = error {
                    print(error)
                    completionHandler(nil)
                }
                if let authenticated = authDataResult {
                    completionHandler(authenticated.user)
                }
            })
        }
    }
    
    func changePassword(fromPassword: String, toPassword: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        reauthenticateUser(currentPassword: fromPassword) { (user) in
            if let u = user {
                u.updatePassword(to: toPassword, completion: { (error) in
                    if let error = error {
                        print(error)
                        completionHandler(false)
                        return
                    } else {
                        Auth.auth().signIn(withEmail: u.email!, password: toPassword, completion: nil)
                        completionHandler(true)
                    }
                })
            } else {
                completionHandler(false)
            }
        }
    }
    
    func changeEmail(password: String, toEmail: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        reauthenticateUser(currentPassword: password) { (user) in
            if let u = user {
                u.updateEmail(to: toEmail, completion: { (error) in
                    if let error = error {
                        print(error)
                        completionHandler(false)
                        return
                    } else {
                        Auth.auth().signIn(withEmail: toEmail, password: password, completion: nil)
                        self.email = toEmail
                        completionHandler(true)
                    }
                })
            } else {
                completionHandler(false)
            }
        }
    }
    
    func changeUsername(password: String, toUsername: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        if !isFBAuth {
            reauthenticateUser(currentPassword: password) { (user) in
                if let UID = self.UID, let _ = user {
                    self.changeUsername(UID: UID, toUsername: toUsername)
                    completionHandler(true)
                }
                completionHandler(false)
            }
        } else {
            if let UID = self.UID {
                self.changeUsername(UID: UID, toUsername: toUsername)
                completionHandler(true)
            }
        }
    }
    
    private func changeUsername(UID: String, toUsername: String) {
        let path = "Accounts/\(UID)/Username"
        let database = Database.database().reference()
        self.username = toUsername
        database.child(path).setValue(toUsername)
    }
}
