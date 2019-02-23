//
//  FlagCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/22/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class FlagCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var flaggedByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var flag: Flag? {
        didSet{
            initCell()
        }
    }
    
    private func initCell() {
        
        if let flag = flag {
            
            reasonLabel.text = flag.reason
            flaggedByLabel.text = flag.issuer.username
            dateLabel.text = flag.date.detail
            
        }
        
    }

}
