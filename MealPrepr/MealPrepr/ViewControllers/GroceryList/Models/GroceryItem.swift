//
//  Grocery.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/19/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation

class GroceryItem {
    
    var id: String?
    var ingredient: Ingredient!
    var status: GroceryStatus = .Need
    
    enum GroceryStatus: String {
        case Have = "5"
        case Need = "10"
    }
    
    var quantity: Decimal? {
        get {
            return self.ingredient?.quantity
        }
        
        set {
            self.ingredient?.quantity = newValue
        }
    }
    
    var unit: String? {
        get {
            return self.ingredient?.unit
        }
        
        set {
            self.ingredient?.unit = newValue
        }
    }
    
    var title: String? {
        get {
            return self.ingredient?.title
        }
        
        set {
            self.ingredient?.title = newValue
        }
    }
    
    init(ingredient: Ingredient, status: GroceryStatus = .Need) {
        self.ingredient = ingredient
        self.status = status
    }
    
    private func mergeGroceryItem(groceryItem: GroceryItem) -> Bool {
        
        if let title = self.title,
            let unit = self.unit,
            let quantity = self.quantity,
            groceryItem.title?.lowercased() == title.lowercased(),
            groceryItem.unit == unit,
            let groceryQuantity = groceryItem.quantity,
            groceryItem.status == self.status {
            
            self.quantity = groceryQuantity + quantity
            return true
            
        }
        
        return false
        
    }
    
    func addGroceryItemToList(groceryList: [GroceryItem]) -> [GroceryItem] {
        
        var list = groceryList
        
        for item in groceryList {
            
            if item.mergeGroceryItem(groceryItem: self) {
                return list
            }
            
        }
        
        list.append(self)
        
        return list
    }
    
    func toString() -> String {
        return ingredient.toString() + status.rawValue.description
    }
    
    func tryMergeExcludingSelf(groceryList: [GroceryItem]) {
        
        var list = groceryList
        
        for item in groceryList {
            
            if item.mergeGroceryItem(groceryItem: self) {
                
                
                
            }
            
        }
        
    }
    
}
