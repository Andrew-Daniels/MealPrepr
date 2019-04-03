//
//  AccountModel.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 4/1/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit

class AccountModel: FirebaseModel, IFirebaseModel {

    var email: String!
    var categories = [String]()
    var dateJoined: Date!
    var savedRecipes = [String: String]()
    var userLevel: Account.UserLevel!
    var username: String!
    var isFBAuth: Bool = false
    
    //IFirebaseModel
    var id: String!
    var path: String! = "Accounts"
    var updateData: [String : Any] {
        get {
            return [
                "Username": self.username,
                "UserLevel": self.userLevel.rawValue,
                "SavedRecipes": self.savedRecipes,
                "DateJoined": self.dateJoined.description,
                "Categories": self.categories
            ]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case categories = "Categories"
        case dateJoined = "DateJoined"
        case savedRecipes = "SavedRecipes"
        case userLevel = "UserLevel"
        case username = "Username"
    }
    
    init(id: String?) {
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories) ?? []
        
        if let date = try container.decodeIfPresent(String.self, forKey: .dateJoined) {
            self.dateJoined = Date.dateFromFirebaseString(dateString: date)
        }
        
        self.savedRecipes = try container.decodeIfPresent([String: String].self, forKey: .savedRecipes) ?? [String: String]()
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.userLevel = try container.decodeIfPresent(Account.UserLevel.self, forKey: .userLevel)
        
    }
    
    // MARK: IFirebaseModel
    func populate(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        
        self.getModelForId(id: self.id) { (accountModel: AccountModel) in
            self.username = accountModel.username
            self.email = accountModel.email
            self.categories = accountModel.categories
            self.dateJoined = accountModel.dateJoined
            completionHandler(true)
        }
        
    }
    
    
    
}

