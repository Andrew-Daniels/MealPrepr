//
//  GroceryListCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/19/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class GroceryListCell: UITableViewCell {
    
    @IBOutlet weak var editQuantityBtn: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    var groceryItem: GroceryItem! {
        didSet {
            initCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initCell() {
        
        guard let status = groceryItem.status,
            let ingredient = groceryItem.ingredient else { return }
        
        var image: UIImage?
        
        if status == .Need {
            
            quantity.text = "\(ingredient.quantity!) \(ingredient.unit!)"
            image = UIImage(named: "Done_Black")?.withRenderingMode(.alwaysTemplate)
            
        } else {
            
            image = UIImage(named: "Done_Black")?.withRenderingMode(.alwaysTemplate)
        }
        
        title.text = ingredient.title
        indicator.image = image
        indicator.tintColor = redColor
        
    }

    @IBAction func editQuantityBtnClicked(_ sender: Any) {
        
        
        
    }
}
