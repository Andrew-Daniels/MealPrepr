//
//  Flag.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/5/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Flag {
    
    var uid: String?
    var date: Date!
    var issuer: AccountModel!
    var reason: String!
    var recipeGUID: String!
    
    var flagDict: [String: Any] {
        get {
            return [
                "Issuer": issuer.UID!,
                "Date": date.description,
                "Reason": reason
            ]
        }
    }
    
    init() {
        
    }
    
    init(recipeGUID: String, flagInfo: (key: String, value: [String : String])) {
        
        self.recipeGUID = recipeGUID
        self.uid = flagInfo.key
        
        if let dateCreated = flagInfo.value["Date"] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            self.date = dateFormatter.date(from: dateCreated)
            if self.date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
                self.date = dateFormatter.date(from: dateCreated)
            }
        }
        
        if let issuerUID = flagInfo.value["Issuer"] {
            let issuer = Account(UID: issuerUID, completionHandler: { (created) in
                if !created {
                    print("Issuer for flag couldn't be found")
                }
            })
            self.issuer = issuer
        }
        
        if let reason = flagInfo.value["Reason"] {
            self.reason = reason
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
