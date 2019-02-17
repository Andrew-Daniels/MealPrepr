//
//  CategoryCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/15/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class SelectorCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initCell() {
        cancelImageView.image = UIImage(named: "Cancel")?.withRenderingMode(.alwaysTemplate)
        cancelImageView.tintColor = .white
    }

}
