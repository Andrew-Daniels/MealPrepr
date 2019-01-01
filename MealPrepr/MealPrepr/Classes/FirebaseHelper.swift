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

        var ingredients = [[String: String]]()
        var utensils = [String]()
        var instructions = [[String: Any]]()
        
        for ingredient in recipe.ingredients {
            var ingredientDict = [String: String]()
            ingredientDict["Title"] = ingredient.title
            ingredientDict["Quantity"] = "\(ingredient.quantity)"
            ingredientDict["Unit"] = ingredient.unit
            ingredients.append(ingredientDict)
        }
        
        for utensil in recipe.utensils {
            utensils.append(utensil)
        }
        
        for instruction in recipe.instructions {
            var instructionDict = [String: Any]()
            instructionDict["Instruction"] = instruction.instruction
            instructionDict["Ingredients"] = instruction.ingredientsArray
            instructionDict["Type"] = instruction.type.rawValue
            instructionDict["TimeInMinutes"] = instruction.timeInMinutes
            instructions.append(instructionDict)
        }
        
        let recipeDict: [String: Any] = [
            "Creator": userId,
            "Title": recipe.title!,
            "CaloriesPerServing": recipe.calServing!,
            "NumServings": recipe.numServings!,
            "Ingredients": ingredients,
            "Utensils": utensils,
            "Instructions": instructions
        ]
        
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
