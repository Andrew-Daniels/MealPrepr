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
    private var downloadedPhotos: [String: UIImage]!
    var creatorUID: String!
    var photoPaths: [String]!
    var GUID: String!
    var delegate: RecipeDelegate?
    private var cook: (minutes: Int, hours: Int)!
    private var prep: (minutes: Int, hours: Int)!
    
    var numIngredients: Int {
        get {
            if let ingredients = ingredients {
                return ingredients.count
            }
            return 0
        }
    }
    
    var totalCookTime: (minutes: Int, hours: Int) {
        get {
            //Calculate cook time here
            if cook == nil {
                var timeInMinutes = 0
                if let ints = instructions {
                    for i in ints {
                        if i.type == .Cook {
                            if let time = i.timeInMinutes {
                                timeInMinutes += time
                            }
                        }
                    }
                }
                cook = RecipeHelper.parseTimeInMinutesForPickerView(timeInMinutes: timeInMinutes)
            }
            return cook
        }
    }
    
    var totalPrepTime: (minutes: Int, hours: Int) {
        get {
            //Calculate preptime here
            if prep == nil {
                var timeInMinutes = 0
                if let ints = instructions {
                    for i in ints {
                        if i.type == .Prep {
                            if let time = i.timeInMinutes {
                                timeInMinutes += time
                            }
                        }
                    }
                }
                prep = RecipeHelper.parseTimeInMinutesForPickerView(timeInMinutes: timeInMinutes)
            }
            return prep
        }
    }
    
    private var ingredientsArray: [[String: String]] {
        get{
            var array = [[String: String]]()
            for ingredient in self.ingredients {
                var ingredientDict = [String: String]()
                ingredientDict["Title"] = ingredient.title
                if let quantity = ingredient.quantity {
                    ingredientDict["Quantity"] = "\(quantity)"
                }
                ingredientDict["Unit"] = ingredient.unit
                array.append(ingredientDict)
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
                "Creator": creatorUID!,
                "Title": title!,
                "CaloriesPerServing": calServing!,
                "NumServings": numServings!,
                "Ingredients": ingredientsArray,
                "Utensils": utensils,
                "Instructions": instructionsArray,
                "Photos": photoPaths
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
        self.creatorUID = creator
    }
    
    init(recipeData: (key: Any, value: Any)) {
        
            self.GUID = recipeData.key as? String // Creator's username
            if let recipeValue = recipeData.value as? [String: Any] {
                if let ingredients = recipeValue["Ingredients"] as? [[String: Any]] {
                    var recipeIngredients = [Ingredient]()
                    for ingredient in ingredients {
                        let i = Ingredient()
                        i.title = ingredient["Title"] as? String
                        i.quantity = Decimal(string: ingredient["Quantity"] as? String ?? "")
                        i.unit = ingredient["Unit"] as? String
                        recipeIngredients.append(i)
                    }
                    self.ingredients = recipeIngredients
                }
                if let instructions = recipeValue["Instructions"] as? [[String: Any]] {
                    var recipeInstructions = [Instruction]()
                    for instruction in instructions {
                        let i = Instruction()
                        i.instruction = instruction["Instruction"] as? String
                        i.timeInMinutes = instruction["TimeInMinutes"] as? Int
                        if let type = instruction["Type"] as? Int {
                            i.type = Instruction.CookType(rawValue: type) ?? .Prep
                        }
                        let ingredientIndexes = instruction["Ingredients"] as? [Int]
                        i.setIngredientsWithIngredientArray(ingredientIndexes: ingredientIndexes, availableIngredients: self.ingredients)
                        recipeInstructions.append(i)
                    }
                    self.instructions = recipeInstructions
                }
                if let utensils = recipeValue["Utensils"] as? [String] {
                    self.utensils = utensils
                }
                if let photoPaths = recipeValue["Photos"] as? [String] {
                    self.photoPaths = photoPaths
                    self.downloadedPhotos = [String: UIImage]()
                    for path in self.photoPaths {
                        FirebaseHelper().downloadImage(atPath: path) { (image) in
                            self.downloadedPhotos[path] = image
                            self.delegate?.photoDownloaded(sender: self)
                        }
                    }
                }
                if let caloriesPerServing = recipeValue["CaloriesPerServing"] as? String,
                    let numServings = recipeValue["NumServings"] as? String,
                    let title = recipeValue["Title"] as? String {
                    self.title = title
                    self.numServings = numServings
                    self.calServing = caloriesPerServing
                }
                if let creatorUID = recipeValue["Creator"] as? String {
                    self.creatorUID = creatorUID
                }
            }
    }
    
    func photoAtIndex(index: Int) -> UIImage? {
        let key = photoPaths[index]
        if downloadedPhotos != nil {
            return downloadedPhotos[key]
        } else {
            return photos[index]
        }
    }
    
    func save(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        if let creatorUID = creatorUID {
            FirebaseHelper().saveRecipe(recipe: self, userId: creatorUID) { (success) in
                completionHandler(success)
            }
        }
    }
    
    func delete() {
        
    }
}
