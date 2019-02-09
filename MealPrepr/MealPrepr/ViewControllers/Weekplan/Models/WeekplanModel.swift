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
                "Owner": owner!,
                "DateCreated": dateCreated?.description ?? Date().description,
                "Recipes": recipesArray
            ]
        }
    }
    
    private var recipesArray: [[String: Any]] {
        get {
            var array = [[String: Any]]()
            if let recipes = self.recipes {
                for recipe in recipes {
                    var recipeDict = [String: Any]()
                    recipeDict["Recipe"] = recipe.GUID!
                    recipeDict["Status"] = recipe.weekplanStatus?.rawValue ?? RecipeStatus.Active.rawValue
                    array.append(recipeDict)
                }
            }
            return array
        }
    }
    
    init() {
        self.recipes = []
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
    
}
