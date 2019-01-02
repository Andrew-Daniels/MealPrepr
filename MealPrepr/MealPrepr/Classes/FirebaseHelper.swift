//
//  FirebaseHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/7/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class FirebaseHelper {
    
    private var database: DatabaseReference!
    private var storage: StorageReference!
    
    init() {
        self.database = Database.database().reference()
        self.storage = Storage.storage().reference()
    }
    
    public func saveRecipe(recipe: Recipe, userId: String) {
        let path = "Recipes/"
        let reference = database.child(path).childByAutoId()
        let recipeDict = recipe.recipeDict
        
        let updates = [
            path + "\(reference.key)": recipeDict
        ]
        
        database.updateChildValues(updates)
    }
    
    public func checkUsernameAvailability(username: String?, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        if let username = username {
            
            let path = "Accounts"
            self.database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                if let accounts = snapshot.value as? NSDictionary {
                    for (_, value) in accounts {
                        if let accountInfo = value as? [String: Any] {
                            for (key, value) in accountInfo {
                                if let u = value as? String, key == "Username", u.lowercased() == username.lowercased() {
                                    completionHandler(false)
                                    return
                                }
                            }
                            completionHandler(true)
                        }
                    }
                }
            }
        }
    }
    public func saveAccount(account: Account) {
        if let username = account.username,
            let UID = account.UID {
            
            let userLevel = account.userLevel
            
            let path = "Accounts/\(UID)"
            self.database.child(path).child("Username").setValue(username)
            self.database.child(path).child("UserLevel").setValue(userLevel.rawValue)
        }
    }
    
    public func retrieveAccountInfo(UID: String, completionHandler: @escaping (_ isResponse : (username: String?, userLevel: Int?)) -> Void) {
        let path = "Accounts/\(UID)"
        var username: String?
        var userLevel: Int?
        
        self.database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            if let accountInfo = snapshot.value as? [String: Any] {
                for (key, value) in accountInfo {
                    if key == "Username" {
                        username = value as? String
                    }
                    else if key == "UserLevel" {
                        userLevel = value as? Int
                    }
                }
                completionHandler((username: username, userLevel: userLevel))
            }
        }
    }
    
}
