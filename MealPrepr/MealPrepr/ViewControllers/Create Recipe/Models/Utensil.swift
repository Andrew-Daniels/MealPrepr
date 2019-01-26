//
//  Utensil.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/9/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class Utensil {
    var title: String!
    var photoPath: String! {
        didSet {
            FirebaseHelper().downloadImage(atPath: self.photoPath, renderMode: .alwaysTemplate) { (image) in
                self.photo = image
                self.delegate?.photoDownloaded(sender: self)
            }
        }
    }
    var photo: UIImage!
    var delegate: UtensilDelegate?
    
    init() {
        
    }
    
    init(utensilData: (key: Any, value: Any)) {
        self.title = utensilData.key as? String
        self.photoPath = utensilData.value as? String
        FirebaseHelper().downloadImage(atPath: self.photoPath, renderMode: .alwaysTemplate) { (image) in
            self.photo = image
            self.delegate?.photoDownloaded(sender: self)
        }
    }
}
