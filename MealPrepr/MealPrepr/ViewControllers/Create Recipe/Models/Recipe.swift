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
    
    func save(account: Account) {
        if let UID = account.UID {
            FirebaseHelper().saveRecipe(recipe: self, userId: UID)
        }
    }
    
    func delete() {
        
    }
}
