//
//  ValidationHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//
import Foundation

struct ValidationHelper {
    
    public static func validateIngredientTitle(ingredientTitle: String?, availableIngredients: [Ingredient]!) -> String? {
        if let errorMsg = self.checkIfEmpty(text: ingredientTitle) {
            return errorMsg
        }
        if let availableIngredients = availableIngredients {
            if availableIngredients.contains(where: { (ing) -> Bool in
                if ing.title.lowercased() == ingredientTitle?.lowercased() {
                    return true
                }
                return false
            }) {
                return ErrorHelper.getErrorMsg(errorKey: .IngredientTitleExists)
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
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
        }
        if (username.isEmpty) {
            return ErrorHelper.getErrorMsg(errorKey: .Empty)
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
