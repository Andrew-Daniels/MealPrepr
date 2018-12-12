//
//  File.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

class Ingredient {
    
    var title: String
    var quantity: Decimal
    var unit: String
    
    init(title: String, quantity: Decimal, unit: String) {
        self.title = title
        self.quantity = quantity
        self.unit = unit
    }
}
