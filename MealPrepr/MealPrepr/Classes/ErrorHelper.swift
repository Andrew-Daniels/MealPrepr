//
//  ErrorHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

struct ErrorHelper {
    
    public enum ErrorKey: Int {
        case IncorrectEmailFormat
        case EightCharMin
        case UsernameTaken
        case Empty
        case NoErrors
    }
    
    public static func getErrorMsg(errorKey: ErrorKey) -> String? {
        switch(errorKey) {
        case .IncorrectEmailFormat:
            return "Email is not the correct format"
        case .UsernameTaken:
            return "This username is already taken"
        case .EightCharMin:
            return "Password must be 8 characters minimum"
        case .Empty:
            return "Field cannot be left blank"
        case .NoErrors:
            return nil
        }
    }
//    public static func getFirebaseErrorMsg() -> String? {
//
//    }
}
