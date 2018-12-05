//
//  ErrorHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

struct ErrorHelper {
    
    public enum EmailError: Int {
        case AccountNotCreated
        case IncorrectEmailFormat
        case Empty
    }
    public enum PasswordError: Int {
        case EightCharMin
        case Empty
    }
    public enum UsernameError: Int {
        case UsernameTaken
        case Empty
    }
    
    public static func getPasswordErrorMessage(error: PasswordError) -> String {
        switch(error) {
        case .EightCharMin:
            return "Password must be 8 characters minimum"
        case .Empty:
            return "Password field cannot be left blank"
        }
    }
    public static func getUsernameErrorMessage(error: UsernameError) -> String {
        switch(error) {
        case .UsernameTaken:
            return "This username is already taken"
        case .Empty:
            return "Username field cannot be left blank"
        }
    }
    public static func getEmailErrorMessage(error: EmailError) -> String {
        switch(error) {
        case .AccountNotCreated:
            return "No account exists with this email"
        case .IncorrectEmailFormat:
            return "Email is not the correct format"
        case .Empty:
            return "Email field cannot be left blank"
        }
    }
    
}
