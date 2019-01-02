//
//  Recipe.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/31/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    
    var title: String!
    var calServing: String!
    var numServings: String!
    var ingredients: [Ingredient]!
    var utensils: [String]!
    var instructions: [Instruction]!
    var photos: [UIImage]!
    var creator: String!
    
    var numIngredients: Int {
        get {
            if let ingredients = ingredients {
                return ingredients.count
            }
            return 0
        }
    }
    
    var totalCookTime: Int {
        get {
            //Calculate cook time here
            return 0
        }
    }
    
    var totalPrepTime: Int {
        get {
            //Calculate preptime here
            return 0
        }
    }
    
    private var ingredientsArray: [[String: String]] {
        get{
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
    
    private var utensilsArray: [String] {
        get {
            var array = [String]()
            for utensil in self.utensils {
                array.append(utensil)
            }
            return array
        }
    }
    
    private var instructionsArray: [[String: Any]] {
        get {
            var array = [[String: Any]]()
            for instruction in self.instructions {
                var instructionDict = [String: Any]()
                instructionDict["Instruction"] = instruction.instruction
                instructionDict["Ingredients"] = instruction.ingredientsDict(availableIngredients: self.ingredients)
                instructionDict["Type"] = instruction.type.rawValue
                instructionDict["TimeInMinutes"] = instruction.timeInMinutes
                array.append(instructionDict)
            }
            return array
        }
    }
    
    var recipeDict: [String: Any] {
        get {
            return [
                "Creator": creator!,
                "Title": title!,
                "CaloriesPerServing": calServing!,
                "NumServings": numServings!,
                "Ingredients": ingredientsArray,
                "Utensils": utensilsArray,
                "Instructions": instructionsArray
            ]
        }
    }
    
    init() {
        
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [String], instructions: [Instruction]) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [String], instructions: [Instruction], photos: [UIImage]) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
        self.photos = photos
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [String], instructions: [Instruction], photos: [UIImage], creator: String?) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
        self.photos = photos
        self.creator = creator
    }
    
    func save() {
        if let creator = creator {
            FirebaseHelper().saveRecipe(recipe: self, userId: creator)
        }
    }
    
    func delete() {
        
    }
}
