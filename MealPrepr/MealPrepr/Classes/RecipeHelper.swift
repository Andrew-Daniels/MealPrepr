//
//  RecipeHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/29/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

class RecipeHelper {
    
    public static func parseTimeInMinutesForPickerView(timeInMinutes: Int) -> (minutes: Int, hours: Int) {
        let minutes = timeInMinutes % 60
        let hours = Int(timeInMinutes / 60)
        return (minutes: minutes, hours: hours)
    }
}
