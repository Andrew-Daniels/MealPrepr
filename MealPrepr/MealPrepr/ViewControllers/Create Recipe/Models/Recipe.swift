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
    var utensils: [Utensil]!
    var instructions: [Instruction]!
    var photos = [Int: UIImage]()
    var dateCreated: Date!
    var status: Status = .Active
    private var downloadedPhotos: [String: UIImage]!
    var creatorUID: String!
    var photoPaths: [String]!
    var GUID: String!
    var recipeDelegate: RecipeDelegate?
    var utensilDelegate: UtensilDelegate?
    var weekplanStatus: WeekplanModel.RecipeStatus?
    var reviews = [Review]()
    var flags = [Flag]()
    var reviewCount = 0
    private var category: String?
    private var cook: (minutes: Int, hours: Int)!
    private var prep: (minutes: Int, hours: Int)!
    
    enum Status: Int {
        case Active
        case Deleted
        case Inactive
    }
    
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
    
    private var utensilArray: [String] {
        get {
            var array = [String]()
            for utensil in self.utensils {
                array.append(utensil.title)
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
                "Utensils": utensilArray,
                "Instructions": instructionsArray,
                "Photos": photoPaths,
                "DateCreated": dateCreated.description,
                "Status": status.rawValue
            ]
        }
    }
    
    init() {
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [Utensil], instructions: [Instruction]) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [Utensil], instructions: [Instruction], photos: [Int: UIImage]) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
        self.photos = photos
    }
    
    init(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [Utensil], instructions: [Instruction], photos: [Int: UIImage], creator: String?) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
        self.photos = photos
        self.creatorUID = creator
    }
    
    init(guid: String, recipeValue: [String: Any]) {
        self.GUID = guid
        self.initWithRecipeValue(recipeValue: recipeValue)
    }
    
    init(recipeData: (key: Any, value: Any)) {
        self.GUID = recipeData.key as? String // Creator's username
        if let recipeValue = recipeData.value as? [String: Any] {
            self.initWithRecipeValue(recipeValue: recipeValue)
        }
    }
    
    func photoAtIndex(index: Int) -> UIImage? {
        if index > photoPaths.count {
            if downloadedPhotos != nil {
                let key = photoPaths[index]
                return downloadedPhotos[key]
            }
        }
        return photos[index]
    }
    
    func save(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        if let creatorUID = creatorUID {
            if self.dateCreated == nil {
                self.dateCreated = Date()
            }
            FirebaseHelper().saveRecipe(recipe: self, userId: creatorUID) { (success) in
                completionHandler(success)
            }
        }
    }
    
    func delete() {
        FirebaseHelper().deleteRecipe(recipe: self)
    }
    
    func update(title: String, calServing: String, numServings: String, ingredients: [Ingredient], utensils: [Utensil], instructions: [Instruction], photos: [Int: UIImage]) {
        self.title = title
        self.calServing = calServing
        self.numServings = numServings
        self.ingredients = ingredients
        self.utensils = utensils
        self.instructions = instructions
        self.photos = photos
    }
    
    private func initWithRecipeValue(recipeValue: [String: Any]) {
        let fbh = FirebaseHelper()
        
        if let dateCreated = recipeValue["DateCreated"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            self.dateCreated = dateFormatter.date(from: dateCreated)
            if self.dateCreated == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
                self.dateCreated = dateFormatter.date(from: dateCreated)
            }
        }
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
            var array = [Utensil]()
            for utensil in utensils {
                let u = Utensil()
                u.title = utensil
                fbh.loadUtensil(utensil: u) { (success) in
                    if success {
                        self.utensilDelegate?.photoDownloaded(sender: u)
                    }
                }
                array.append(u)
            }
            self.utensils = array
        }
        if let photoPaths = recipeValue["Photos"] as? [String] {
            self.photoPaths = photoPaths
            self.downloadedPhotos = [String: UIImage]()
            for (index, path) in self.photoPaths.enumerated() {
                fbh.downloadImage(atPath: path, renderMode: .alwaysOriginal) { (image) in
                    self.downloadedPhotos[path] = image
                    self.photos[index] = image
                    self.recipeDelegate?.photoDownloaded(sender: self)
                    self.recipeDelegate?.photoDownloaded(photoPath: index)
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
        if let status = recipeValue["Status"] as? Int {
            self.status = Status.init(rawValue: status) ?? .Inactive
        }
        
        fbh.loadFlagsForRecipe(recipe: self) { (completed) in
            if completed {
                print("flags loaded successfully")
            } else {
                print("flags weren't loaded")
            }
        }
    }
    
    func getCategory(account: Account, completionHandler: @escaping (_ isResponse : String?) -> Void) -> String? {
        if let c = category {
            return c
        } else {
            FirebaseHelper().getCategoryForRecipe(recipe: self, account: account) { (category) in
                self.category = category
                completionHandler(category)
            }
        }
        return nil
    }
    
    func getCategory() -> String? {
        return category
    }
    
    func setCategory(category: String?) {
        self.category = category
    }
    
}
