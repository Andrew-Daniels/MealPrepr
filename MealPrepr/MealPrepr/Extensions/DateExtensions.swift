//
//  DateExtensions.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/13/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation

extension Date {
    var detail: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
    static func dateFromFirebaseString(dateString: String) -> Date? {
        var date: Date?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        date = dateFormatter.date(from: dateString)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
            date = dateFormatter.date(from: dateString)
        }
        return date
    }
}
