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
    
    public func loadRecipes(completionHandler: @escaping (_ isResponse : [Recipe]) -> Void) {
        let path = "Recipes/"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            var recipes = [Recipe]()
            if let value = snapshot.value as? NSDictionary {
                for recipeData in value {
                    let recipe = Recipe(recipeData: recipeData)
                    recipes.append(recipe)
                }
            }
            completionHandler(recipes)
        }
    }
    
    public func loadRecipe(guid: String, completionHandler: @escaping (_ isResponse : Recipe) -> Void) {
        let path = "Recipes/\(guid)"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                completionHandler(Recipe(guid: guid, recipeValue: value))
            }
        }
    }
    
    public func loadUtensil(utensil: Utensil, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        guard let title = utensil.title else { return }
        let path = "Utensils/"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                for utensilData in value {
                    if let key = utensilData.key as? String, title == key {
                        utensil.photoPath = utensilData.value as? String
                        completionHandler(true)
                    }
                }
            }
        }
    }
    
    public func loadUtensils(completionHandler: @escaping (_ isResponse : [Utensil]) -> Void) {
        let path = "Utensils/"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            var utensils = [Utensil]()
            if let value = snapshot.value as? NSDictionary {
                for utensilData in value {
                    let utensil = Utensil(utensilData: utensilData)
                    utensils.append(utensil)
                }
            }
            completionHandler(utensils)
        }
    }
    
    public func downloadImage(atPath: String, completionHandler: @escaping (_ isResponse : UIImage) -> Void) {
        storage.child(atPath).getData(maxSize: (1000 * 500)) { (data, error) in
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            }
        }
    }
    
    public func saveRecipe(recipe: Recipe, userId: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        let path = "Recipes/"
        let reference = database.child(path).childByAutoId()
        var photoPaths = [String]()
        
        for (index, photo) in recipe.photos.enumerated() {
            if let data = photo.pngData() {
                let photoRef = storage.child(path + "\(reference.key)" + "\(index)")
                    photoRef.putData(data, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        // Uh-oh, an error occurred!
                        completionHandler(false)
                        return
                    }
                    
                    photoRef.downloadURL { (url, error) in
                        guard let _ = url else {
                            // Uh-oh, an error occurred!
                            completionHandler(false)
                            return
                        }
                        photoPaths.append(photoRef.fullPath)
                        if (photoPaths.count == recipe.photos.count) {
                            recipe.photoPaths = photoPaths
                            
                            let updates = [
                                path + "\(reference.key)": recipe.recipeDict
                            ]
                            
                            self.database.updateChildValues(updates)
                            completionHandler(true)
                        }
                    }
                }
            }
        }
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
    
    public func loadCategories(account: Account) {
        if let UID = account.UID {
            let path = "Accounts/\(UID)/Categories"
//            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
//                if let value = snapshot.value as? [String] {
//                    account.recipeCategories = value
//                    account.recipeCategories.insert("Favorites", at: 0)
//                    account.recipeCategories.insert("All", at: 0)
//                }
//            }
            database.child(path).observe(.value) { (snapshot) in
                if let value = snapshot.value as? [String] {
                    account.recipeCategories = value
                    account.savedCategories()
                }
            }
        }
    }
    
    public func saveCategory(account: Account) {
        if let UID = account.UID {
            let path = "Accounts/\(UID)/Categories"
            account.savingCategories()
            database.child(path).setValue(account.recipeCategories)
            account.savedCategories()
        }
    }
    
    private func recipesFromSnapshot(snapshot: DataSnapshot, completionHandler: @escaping (_ isResponse : [Recipe]) -> Void) {
        var recipes = [Recipe]()
        if let value = snapshot.value as? NSDictionary {
            for recipeInfo in value {
                if let guid = recipeInfo.key as? String {
                    self.loadRecipe(guid: guid, completionHandler: { (recipe) in
                        recipes.append(recipe)
                        if recipes.count == value.count {
                            completionHandler(recipes)
                        }
                    })
                }
            }
        } else {
            completionHandler(recipes)
        }
    }
    
    public func loadRecipesForCategory(account: Account, category: String, completionHandler: @escaping (_ isResponse : [Recipe]) -> Void) {
        if let UID = account.UID {
            let path = "Accounts/\(UID)/SavedRecipes"
            if category == "All" {
                database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                    self.recipesFromSnapshot(snapshot: snapshot, completionHandler: { (recipes) in
                        completionHandler(recipes)
                    })
                }
            } else {
                database.child(path).queryOrderedByValue().queryEqual(toValue: category).observeSingleEvent(of: .value, with: { (snapshot) in
                    self.recipesFromSnapshot(snapshot: snapshot, completionHandler: { (recipes) in
                        completionHandler(recipes)
                    })
                }) { (error) in
                    print(error)
                }
            }
        }
    }
}
