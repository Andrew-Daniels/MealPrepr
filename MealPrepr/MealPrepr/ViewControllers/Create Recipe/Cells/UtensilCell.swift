//
//  UtensilCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class UtensilCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var isSel: Bool = false {
        didSet {
            let redColor = UIColor(red: 242/255, green: 66/255, blue: 54/255, alpha: 1.0)
            self.backgroundColor = isSel ? redColor : UIColor.clear
            self.titleLabel.textColor = isSel ? UIColor.black : UIColor.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
    }
}
