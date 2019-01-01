//
//  Instruction.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/24/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

class Instruction {
    
    enum CookType: Int {
        case Prep
        case Cook
    }
    
    var ingredients = [Ingredient]()
    var type: CookType = .Prep
    var instruction: String!
    var timeInMinutes: Int!
    
    var ingredientsArray: [[String: String]] {
        get {
            var array = [[String: String]]()
            for ingredient in self.ingredients {
                var ingredientDict = [String: String]()
                ingredientDict["Title"] = ingredient.title
                ingredientDict["Quantity"] = "\(ingredient.quantity)"
                ingredientDict["Unit"] = ingredient.unit
                array.append(ingredientDict)
            }
            return array
        }
    }
    
    init() {
        
    }
    
    
}
