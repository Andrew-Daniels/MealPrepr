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
    
    init() {
        
    }
    
    func ingredientsDict(availableIngredients: [Ingredient]) -> [String: Int] {
        var ingredientsDict = [String: Int]()
        for (modelIndex, ingredient) in ingredients.enumerated() {
            let firstIndex = availableIngredients.firstIndex { (ing) -> Bool in
                if ing.toString() == ingredient.toString() {
                    return true
                }
                return false
            }
            guard let nonNilIndex = firstIndex else { return ingredientsDict }
            let index = availableIngredients.startIndex.distance(to: nonNilIndex)
            ingredientsDict["\(modelIndex)"] = index
        }
        return ingredientsDict
    }
    
    func setIngredientsWithIngredientArray(ingredientIndexes: [Int]?, availableIngredients: [Ingredient]) {
        if let indexes = ingredientIndexes {
            for index in indexes {
                let ingredient = availableIngredients[index]
                ingredients.append(ingredient)
            }
        }
    }
}
