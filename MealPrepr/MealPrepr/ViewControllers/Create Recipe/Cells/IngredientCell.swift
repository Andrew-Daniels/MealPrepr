//
//  IngredientCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    var ingredient: Ingredient!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ingredientLabel.text = ingredient.title
        quantityLabel.text = ingredient.quantity?.description
    }
}
