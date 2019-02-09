//
//  Weekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/9/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation

class WeekplanModel {
    
    var recipes: [Recipe]?
    var dateCreated: Date?
    var owner: String?
    
    
    init() {
        self.recipes = []
    }
    
}
