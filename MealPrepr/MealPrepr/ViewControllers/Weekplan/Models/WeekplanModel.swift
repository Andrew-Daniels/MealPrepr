//
//  Weekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/9/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation

class WeekplanModel {
    
    var recipes: [Recipe]?
    var groceryList: [GroceryItem]?
    var groceryListNeedsUpdate = true
    var dateCreated: Date?
    var owner: String?
    var GUID: String?
    
    enum RecipeStatus: String {
        case Active = "Active"
        case Completed = "Completed"
    }
    
    var weekplanDict: [String: Any] {
        get {
            return [
                "DateCreated": dateCreated?.description ?? Date().description,
                "Recipes": recipesArray,
                "GroceryList": groceryListArray
            ]
        }
    }
    
    private var recipesArray: [[String: Any]] {
        get {
            var array = [[String: Any]]()
            if let recipes = self.recipes {
                for recipe in recipes {
                    var recipeDict = [String: Any]()
                    recipe.weekplanStatus = recipe.weekplanStatus ?? RecipeStatus.Active
                    recipeDict[recipe.GUID!] = recipe.weekplanStatus?.rawValue ?? RecipeStatus.Active.rawValue
                    array.append(recipeDict)
                }
            }
            return array
        }
    }
    
    private var groceryListArray: [[String: Any]] {
        
        get {
            var array = [[String: Any]]()
            if let groceryItems = self.groceryList {
                for item in groceryItems {
                    var groceryDict = [String: Any]()
                    let statusString = item.status.rawValue
                    var ingredientDict = item.ingredient.toDict()
                    ingredientDict["Id"] = item.id ?? FirebaseHelper().getAutoId()
                    item.id = ingredientDict["Id"] as? String
                    groceryDict[statusString] = ingredientDict
                    array.append(groceryDict)
                }
            }
            return array
        }
        
    }
    
    init() {
        self.recipes = []
    }
    
    convenience init(owner: String, weekplanValue: [String: Any], completionHandler: @escaping (_ isResponse : WeekplanModel) -> Void) {
        self.init()
        self.owner = owner
        self.GUID = weekplanValue.keys.first
        self.initWithWeekplanValue(weekplanValue: weekplanValue[self.GUID!] as! [String : Any]) { (completed) in
            if completed {
                completionHandler(self)
            }
        }
    }
    
    func save(completionHandler: @escaping (_ isResponse : Bool) -> Void) -> Bool {
        if let _ = owner {
            FirebaseHelper().saveWeekplan(weekplan: self) { (saved) in
                completionHandler(true)
            }
            return true
        }
        completionHandler(false)
        return false
    }
    
    private func initWithWeekplanValue(weekplanValue: [String: Any], completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        
        if let dateCreated = weekplanValue["DateCreated"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            self.dateCreated = dateFormatter.date(from: dateCreated)
            if self.dateCreated == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
                self.dateCreated = dateFormatter.date(from: dateCreated)
            }
        }
        
        if let groceryItems = weekplanValue["GroceryList"] as? [[String: [String: Any]]] {
            
            self.groceryList = []
            self.groceryListNeedsUpdate = false
            
            for item in groceryItems {
                for itemValue in item.values {
                    
                    guard let title = itemValue["Title"] as? String,
                        let quantityString = itemValue["Quantity"] as? String,
                        let unit = itemValue["Unit"] as? String,
                        let quantity = Decimal(string: quantityString),
                        let statusString = item.keys.first,
                        let status = GroceryItem.GroceryStatus(rawValue: statusString) else { break }
                    
                    let ingredient = Ingredient()
                    ingredient.title = title
                    ingredient.quantity = quantity
                    ingredient.unit = unit
                    
                    let groceryItem = GroceryItem(ingredient: ingredient, status: status)
                    if let id = itemValue["Id"] as? String {
                        groceryItem.id = id
                    }
                    groceryList?.append(groceryItem)
                    
                }
                
            }
            
        }
        
        if let recipes = weekplanValue["Recipes"] as? [[String: String]] {
            for recipe in recipes {
                guard let recipeGUID = recipe.keys.first,
                let recipeStatus = recipe[recipeGUID] else { return }
                
                FirebaseHelper().loadRecipe(guid: recipeGUID) { (r) in
                    r.weekplanStatus = RecipeStatus.init(rawValue: recipeStatus) ?? RecipeStatus.Active
                    self.recipes?.append(r)
                    if self.recipes?.count == recipes.count {
                        completionHandler(true)
                    }
                }
                
            }
        }
    }
    
}
