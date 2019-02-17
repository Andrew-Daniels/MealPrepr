//
//  ReviewCellTableViewCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewer: UILabel!
    @IBOutlet weak var reviewDetail: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var review: Review! {
        didSet {
            initCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func initCell() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.layer.borderColor = redColor.cgColor
        self.profileImageView.layer.borderWidth  = 1
        self.profileImageView.backgroundColor = .white
        self.profileImageView.clipsToBounds = true
        self.ratingImageView.tintColor = redColor
        self.ratingImageView.layer.cornerRadius = self.ratingImageView.frame.height / 2
        
        self.reviewDetail.text = review?.reviewDetail
        self.reviewer.text = review!.reviewer.username! + " asks:"
        review.reviewer.getProfilePicture(completionHandler: { (image) in
            
            if let i = image {
                self.profileImageView.image = i
                self.usernameLabel.isHidden = true
            } else {
                self.usernameLabel.isHidden = false
                let text = self.review!.reviewer.username!.uppercased()
                let index = text.index(text.startIndex, offsetBy: 2)
                let finalText = text[..<index]
                self.usernameLabel.text = finalText.description
                self.profileImageView.image = nil
            }
            
        })
        
        if review.taste != .NotRated {
            self.ratingImageView.isHidden = false
            if review.taste == .Like {
                let image = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
                self.ratingImageView.image = image
                self.reviewer.text = review!.reviewer.username! + " liked this recipe."
            } else {
                let image = UIImage(named: "Dislike")?.withRenderingMode(.alwaysTemplate)
                self.ratingImageView.image = image
                self.reviewer.text = review!.reviewer.username! + " disliked this recipe."
            }
        } else {
            self.ratingImageView.isHidden = true
        }
    }
    
}
