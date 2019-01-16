//
//  ValidationHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//
import Foundation
import UIKit

struct ValidationHelper {
    
    public static func validateCategory(account: Account, category: String?) -> String? {
        if let errorMsg = self.checkIfEmpty(text: category) {
            return errorMsg
        }
        
        if account.recipeCategories.contains(category!.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ErrorHelper.getErrorMsg(errorKey: .CategoryExists)
        }
        
        return nil
    }
    
    public static func validateRecipePhotos(photos: [UIImage]) -> String? {
        if photos.count > 0 {
            return nil
        }
        return ErrorHelper.getErrorMsg(errorKey: .NoPhotos)
    }
    
    public static func validateRecipeInstructions(instructions: [Instruction]) -> String? {
        if instructions.count > 0 {
            return nil
        }
        return ErrorHelper.getErrorMsg(errorKey: .NoInstructions)
    }
    
    public static func validateRecipeUtensils(utensils: [Utensil]) -> String? {
        if utensils.count > 0 {
            return nil
        }
        return ErrorHelper.getErrorMsg(errorKey: .NoUtensils)
    }
    
    public static func validateRecipeIngredients(ingredients: [Ingredient]) -> String? {
        if ingredients.count > 0 {
            return nil
        }
        return ErrorHelper.getErrorMsg(errorKey: .NoIngredients)
    }
    
    public static func validateRecipeTitle(title: String?) -> String? {
        if let errorMsg = self.checkIfEmpty(text: title) {
            return errorMsg
        }
        
        
        return nil
    }
    
    public static func validateIngredientTitle(ingredientTitle: String?, availableIngredients: [Ingredient]!, excludingTitle: String?) -> String? {
        if let errorMsg = self.checkIfEmpty(text: ingredientTitle) {
            return errorMsg
        }
        if let availableIngredients = availableIngredients {
            if availableIngredients.contains(where: { (ing) -> Bool in
                if ing.title.lowercased() == ingredientTitle?.lowercased() {
                    if ing.title.lowercased() == excludingTitle?.lowercased() {
                        return false
                    }
                    return true
                }
                return false
            }) {
                return ErrorHelper.getErrorMsg(errorKey: .IngredientTitleExists)
            }
        }
        return nil
    }
    
    public static func validateUtensilTitle(utensilTitle: String?, availableUtensils: [String]!, excludingTitle: String?) -> String? {
        if let errorMsg = self.checkIfEmpty(text: utensilTitle) {
            return errorMsg
        }
        
        if let availableUtensils = availableUtensils {
            if availableUtensils.contains(where: { (uten) -> Bool in
                if uten.lowercased() == utensilTitle?.lowercased() {
                    if uten.lowercased() == excludingTitle?.lowercased() {
                        return false
                    }
                    return true
                }
                return false
            }) {
                return ErrorHelper.getErrorMsg(errorKey: .UtensilTitleExists)
            }
        }
        
        return nil
    }
    
    public static func validateEmail(email: String?) -> String? {
        guard let email = email else {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedEmail.isEmpty) {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailFormatTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validEmailFormat = emailFormatTest.evaluate(with: email)
        
        if (!validEmailFormat) {
            return ErrorHelper.getErrorMsg(errorKey: .IncorrectEmailFormat)
        }
        
        return ErrorHelper.getErrorMsg(errorKey: .NoErrors)
    }
    
    public static func validatePassword(password: String?) -> String? {
        guard let password = password else {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        if (password.isEmpty) {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        if (password.count < 8) {
            return ErrorHelper.getErrorMsg(errorKey: .EightCharMin)
        }
        
        return ErrorHelper.getErrorMsg(errorKey: .NoErrors)
    }
    
    public static func validateUsername(username: String?) -> String? {
        guard let username = username else {
            return ErrorHelper.getErrorMsg(errorKey: .UsernameTwoCharMin)
        }
        if (username.isEmpty) {
            return ErrorHelper.getErrorMsg(errorKey: .UsernameTwoCharMin)
        }
        if (username.count < 2) {
            return ErrorHelper.getErrorMsg(errorKey: .UsernameTwoCharMin)
        }
        return ErrorHelper.getErrorMsg(errorKey: .NoErrors)
    }
    
    public static func checkIfEmpty(text: String?) -> String? {
        guard let text = text else {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        if (text.isEmpty) {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        
        return ErrorHelper.getErrorMsg(errorKey: .NoErrors)
    }
    
    public static func checkIfDecimal(text: String?) -> String? {
        if self.checkIfEmpty(text: text) == nil {
            
            if let _ = text?.decimalValue {
                return ErrorHelper.getErrorMsg(errorKey: .NoErrors)
            }
            return ErrorHelper.getErrorMsg(errorKey: .NotDecimal)
        }
    
        return self.checkIfEmpty(text: text)
        
    }
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var decimalValue: Decimal? {
        return NumFormatter.instance.number(from: self)?.decimalValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
}
