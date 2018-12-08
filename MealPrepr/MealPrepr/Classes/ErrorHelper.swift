//
//  ErrorHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import FirebaseAuth

struct ErrorHelper {
    
    public enum ErrorKey: Int {
        case IncorrectEmailFormat
        case EightCharMin
        case UsernameTaken
        case Empty
        case NoErrors
    }
    
    public enum AuthFieldType {
        case Email
        case Username
        case Password
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
    
    public static func getFirebaseErrorMsg(authErrorCode: AuthErrorCode) -> (errorMsg: String, authFieldType: AuthFieldType) {
        
        switch(authErrorCode) {
        case .invalidCustomToken:
            break;
        case .customTokenMismatch:
            break;
        case .invalidCredential:
            break;
        case .userDisabled:
            break;
        case .operationNotAllowed:
            break;
        case .emailAlreadyInUse:
            return (errorMsg:"This email address is already in use by another account.", authFieldType: .Email)
        case .invalidEmail:
            return (errorMsg:"Email is not the correct format", authFieldType: .Email)
        case .wrongPassword:
            return (errorMsg:"The password entered was incorrect.", authFieldType: .Password)
        case .tooManyRequests:
            break;
        case .userNotFound:
            return (errorMsg:"An account with this email address doesn't exist.", authFieldType: .Email)
        case .accountExistsWithDifferentCredential:
            break;
        case .requiresRecentLogin:
            break;
        case .providerAlreadyLinked:
            break;
        case .noSuchProvider:
            break;
        case .invalidUserToken:
            break;
        case .networkError:
            break;
        case .userTokenExpired:
            break;
        case .invalidAPIKey:
            break;
        case .userMismatch:
            break;
        case .credentialAlreadyInUse:
            break;
        case .weakPassword:
            return (errorMsg: "Password must be 6 characters minimum", authFieldType: .Password)
        case .appNotAuthorized:
            break;
        case .expiredActionCode:
            break;
        case .invalidActionCode:
            break;
        case .invalidMessagePayload:
            break;
        case .invalidSender:
            break;
        case .invalidRecipientEmail:
            break;
        case .missingEmail:
            break;
        case .missingIosBundleID:
            break;
        case .missingAndroidPackageName:
            break;
        case .unauthorizedDomain:
            break;
        case .invalidContinueURI:
            break;
        case .missingContinueURI:
            break;
        case .missingPhoneNumber:
            break;
        case .invalidPhoneNumber:
            break;
        case .missingVerificationCode:
            break;
        case .invalidVerificationCode:
            break;
        case .missingVerificationID:
            break;
        case .invalidVerificationID:
            break;
        case .missingAppCredential:
            break;
        case .invalidAppCredential:
            break;
        case .sessionExpired:
            break;
        case .quotaExceeded:
            break;
        case .missingAppToken:
            break;
        case .notificationNotForwarded:
            break;
        case .appNotVerified:
            break;
        case .captchaCheckFailed:
            break;
        case .webContextAlreadyPresented:
            break;
        case .webContextCancelled:
            break;
        case .appVerificationUserInteractionFailure:
            break;
        case .invalidClientID:
            break;
        case .webNetworkRequestFailed:
            break;
        case .webInternalError:
            break;
        case .nullUser:
            break;
        case .keychainError:
            break;
        case .internalError:
            break;
        }
        
        return (errorMsg: "Basic error message. This error message needs handled", .Email)
    }
}
