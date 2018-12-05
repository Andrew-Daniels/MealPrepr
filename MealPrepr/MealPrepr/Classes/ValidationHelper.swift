//
//  ValidationHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//
import Foundation

struct ValidationHelper {
    
    public static func validateEmail(email: String?) -> ErrorHelper.ErrorKey {
        guard let email = email else {
            return ErrorHelper.ErrorKey.Empty
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedEmail.isEmpty) {
            return ErrorHelper.ErrorKey.Empty
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
            return ErrorHelper.ErrorKey.IncorrectEmailFormat
        }
        
        return ErrorHelper.ErrorKey.NoErrors
    }
    
    public static func validatePassword(password: String?) -> ErrorHelper.ErrorKey {
        guard let password = password else {
            return ErrorHelper.ErrorKey.Empty
        }
        if (password.isEmpty) {
            return ErrorHelper.ErrorKey.Empty
        }
        if (password.count < 8) {
            return ErrorHelper.ErrorKey.EightCharMin
        }
        
        return ErrorHelper.ErrorKey.NoErrors
    }
}
