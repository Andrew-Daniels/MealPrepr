//
//  Review.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation


class Review {
    
    var guid: String!
    var reviewerGUID: String!
    var reviewerUsername: String!
    var reviewDetail: String!
    var recipeGUID: String!
    
    init(guid: String, reviewerGUID: String, reviewerUsername: String, reviewDetail: String, recipeGUID: String) {
        self.guid = guid
        self.reviewerGUID = reviewerGUID
        self.reviewerUsername = reviewerUsername
        self.reviewDetail = reviewDetail
        self.recipeGUID = recipeGUID
    }
    
}
