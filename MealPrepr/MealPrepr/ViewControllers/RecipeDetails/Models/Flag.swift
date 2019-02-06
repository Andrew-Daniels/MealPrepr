//
//  Flag.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/5/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation


class Flag {
    
    var uid: String?
    var date: Date!
    var issuer: Account!
    var reason: String!
    var recipe: Recipe!
    
    var flagDict: [String: Any] {
        get {
            return [
                "Issuer": issuer.UID!,
                "Date": date.description,
                "Reason": reason
            ]
        }
    }
    
    func save() {
        FirebaseHelper().saveFlag(flag: self) { (success) in
            print("Flag saved")
        }
    }
    
    func delete(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        FirebaseHelper().deleteFlag(flag: self) { (success) in
            completionHandler(success)
        }
    }
    
}
