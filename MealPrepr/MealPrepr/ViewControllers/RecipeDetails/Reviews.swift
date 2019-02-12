//
//  Reviews.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let recipeCellIdentifier = "ReviewCell"

class Reviews: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews = [
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Tom", reviewDetail: "This is my review", recipeGUID: ""),
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Mary", reviewDetail: "This is my review also.", recipeGUID: ""),
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Username1994", reviewDetail: "This is my review, isn't it great?! This review is much longer than all the other ones. I hope this still fits on the screen and allows me to read the whole review. If it doesn't I'll be pretty sad. Won't you?", recipeGUID: "")
        ]
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        cell.review = review
        return cell
    }
    
    

}
