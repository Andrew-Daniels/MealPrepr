//
//  Instruction.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/24/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

class Instruction {
    
    enum CookType: Int {
        case Prep
        case Cook
    }
    
    var ingredients = [Ingredient]()
    var type: CookType!
    var instruction: String!
    var timeInMinutes: Int!
    
    init() {
        
    }
}
