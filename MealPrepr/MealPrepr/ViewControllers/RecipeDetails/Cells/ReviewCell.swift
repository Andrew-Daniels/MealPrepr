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
        
        self.reviewDetail.text = review?.reviewDetail
        self.reviewer.text = review?.reviewer.username
        self.profileImageView.image = UIImage()
    }
    
}
