//
//  Review.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation


class Review: AccountDelegate {
    
    var guid: String!
    var reviewer: Account!
    var reviewDetail: String!
    var recipeGUID: String!
    var dateCreated: Date?
    var delegate: ReviewDelegate?
    var taste: Rating?
    var timeAccuracy: Rating?
    
    enum Rating: Int {
        case NotRated = -1
        case Like = 0
        case Dislike = 1
    }
    
    var reviewDict: [String: Any] {
        get {
            return [
                "Reviewer": reviewer.UID!,
                "Recipe": recipeGUID!,
                "ReviewDetail": reviewDetail!,
                "DateCreated": dateCreated?.description ?? Date().description,
                "Taste": taste?.rawValue ?? Rating.NotRated.rawValue,
                "TimeAccuracy": timeAccuracy?.rawValue ?? Rating.NotRated.rawValue
            ]
        }
    }
    
    init() {
        
    }
    
    init(reviewer: Account, reviewDetail: String, recipeGUID: String) {
        self.reviewer = reviewer
        self.reviewDetail = reviewDetail
        self.recipeGUID = recipeGUID
    }
    
    func save(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        FirebaseHelper().saveReview(review: self) { (completed) in
            completionHandler(completed)
        }
    }
    
    func delete() {
        
    }
    
    func accountLoaded() {
        //Load the photo
        delegate?.reviewAccountLoaded()
        self.reviewer.getProfilePicture { (image) in
            self.delegate?.reviewProfileImageLoaded(sender: self)
        }
    }
    
}
