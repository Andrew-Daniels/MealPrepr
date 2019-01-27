//
//  MPTextFieldDelegate.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/5/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation

protocol MPTextFieldDelegate: NSObjectProtocol {
    func mpTextFieldShouldReturn(textField: MPTextField)
    func mpTextFieldTextDidChange(text: String?)
}

extension MPTextFieldDelegate {
    func mpTextFieldTextDidChange(text: String?) {
        
    }
}
