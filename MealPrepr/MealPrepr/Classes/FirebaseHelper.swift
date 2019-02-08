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
    
    public func loadRecipes(recipeDelegate: RecipeDelegate?, completionHandler: @escaping (_ isResponse : [Recipe]) -> Void) {
        let path = "Recipes/"
        database.child(path).queryOrdered(byChild: "Status").queryEqual(toValue: Recipe.Status.Active.rawValue).observe(.childRemoved, with: { (snapshot) in
            let recipeGUID = snapshot.key
            recipeDelegate?.recipeDeleted(GUID: recipeGUID)
        })

        database.child(path).queryOrdered(byChild: "Status").queryEqual(toValue: Recipe.Status.Active.rawValue).observeSingleEvent(of: .value) { (snapshot) in
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
    
    public func loadIngredientUnits(completionHandler: @escaping (_ isResponse : [String]) -> Void) {
        let path = "Units"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String] {
                completionHandler(value.sorted())
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
    
    public func downloadImage(atPath: String, renderMode: UIImage.RenderingMode, completionHandler: @escaping (_ isResponse : UIImage) -> Void) {
        storage.child(atPath).getData(maxSize: (1000 * 500)) { (data, error) in
            if let data = data, let image = UIImage(data: data)?.withRenderingMode(renderMode) {
                completionHandler(image)
            }
        }
    }
    
    public func saveRecipe(recipe: Recipe, userId: String, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        let path = "Recipes/"
        var referenceKey: String!
        if let GUID = recipe.GUID {
            referenceKey = GUID
        } else {
            referenceKey = database.child(path).childByAutoId().key
        }
        var photoPaths = [String]()
        
        if recipe.photos.count > 0 {
            for index in 0...recipe.photos.count {
                let photo = recipe.photos[index]
                if let data = photo?.pngData(), let key = referenceKey {
                    let photoRef = storage.child(path + "\(key)" + "\(index)")
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
                                    path + "\(key)": recipe.recipeDict
                                ]
                                
                                self.database.updateChildValues(updates)
                                recipe.GUID = key
                                completionHandler(true)
                            }
                        }
                    }
                }
            }
        } else {
            
            if let key = referenceKey {
                let updates = [
                    path + "\(key)": recipe.recipeDict
                ]
                self.database.updateChildValues(updates)
                completionHandler(true)
            }
            
        }
        
    }
    
    public func saveFlag(flag: Flag, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        
        let path = "Flags/\(flag.recipe.GUID!)/"
        let reference = database.child(path).childByAutoId()
        let updates = [
            path + "\(reference.key)": flag.flagDict
        ]
        
        findRecipeFlagForUser(recipe: flag.recipe, account: flag.issuer) { (flag) in
            if let f = flag {
                f.delete(completionHandler: { (success) in
                    self.database.updateChildValues(updates)
                })
            } else {
                self.database.updateChildValues(updates)
            }
        }
    }
    
    public func deleteFlag(flag: Flag, completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        if let uid = flag.uid {
            let path = "Flags/\(uid)"
            database.child(path).removeValue()
            completionHandler(true)
            return
        }
        completionHandler(false)
    }
    
    public func findRecipeFlagForUser(recipe: Recipe, account: Account, completionHandler: @escaping (_ isResponse : Flag?) -> Void) {
        let path = "Flags/\(recipe.GUID!)"
        database.child(path)
            .queryOrdered(byChild: "Issuer")
            .queryEqual(toValue: account.UID)
            .observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let flag = Flag()
                flag.uid = snapshot.key
                
                if let dateCreated = value["Date"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
                    flag.date = dateFormatter.date(from: dateCreated)
                    if flag.date == nil {
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
                        flag.date = dateFormatter.date(from: dateCreated)
                    }
                }
                
                if let issuerUID = value["Issuer"] as? String {
                    let issuer = Account(UID: issuerUID, completionHandler: { (created) in
                        if !created {
                            print("Issuer for flag couldn't be found")
                        }
                    })
                    flag.issuer = issuer
                }
                
                if let reason = value["Reason"] as? String {
                    flag.reason = reason
                }
                
                completionHandler(flag)
                return
            }
                completionHandler(nil)
        }
    }
    
    public func saveRecipeToCategory(account: Account, category: String, recipe: Recipe) {
        if let UID = account.UID, let GUID = recipe.GUID {
            let path = "Accounts/\(UID)/SavedRecipes/\(GUID)"
            database.child(path).setValue(category)
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
            if account.dateJoined == nil {
                account.dateJoined = Date()
            }
            FirebaseHelper().loadCategories(account: account)
            
            let path = "Accounts/\(UID)"
            self.database.child(path).child("Username").setValue(username)
            self.database.child(path).child("UserLevel").setValue(userLevel.rawValue)
            self.database.child(path).child("DateJoined").setValue(account.dateJoined?.description ?? Date().description)
        }
    }
    
    public func retrieveAccountInfo(UID: String, completionHandler: @escaping (_ isResponse : (username: String?, userLevel: Int?, dateJoined: Date?)) -> Void) {
        let path = "Accounts/\(UID)"
        var username: String?
        var userLevel: Int?
        var dateJoined: Date?
        
        self.database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            if let accountInfo = snapshot.value as? [String: Any] {
                for (key, value) in accountInfo {
                    if key == "Username" {
                        username = value as? String
                    }
                    else if key == "UserLevel" {
                        userLevel = value as? Int
                    }
                    else if key == "DateJoined" {
                        if let dateString = value as? String {
                            dateJoined = Date.dateFromFirebaseString(dateString: dateString)
                        }
                    }
                }
                completionHandler((username: username, userLevel: userLevel, dateJoined: dateJoined))
            } else {
                completionHandler((username: nil, userLevel: nil, dateJoined: nil))
            }
        }
    }
    
    public func loadCategories(account: Account) {
        if let UID = account.UID {
            account.savingCategories()
            let path = "Accounts/\(UID)/Categories"
            database.child(path).observe(.value) { (snapshot) in
                if let value = snapshot.value as? [String] {
                    account.recipeCategories = value
                }
                account.savedCategories()
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
            if category == allCategoriesString {
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
    
    public func deleteRecipe(recipe: Recipe) {
        if let GUID = recipe.GUID {
            let path = "Recipes/\(GUID)/Status"
            database.child(path).setValue(Recipe.Status.Deleted.rawValue)
        }
    }
}
