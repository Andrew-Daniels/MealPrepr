//
//  HomeRecipesCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class HomeRecipesCell: UICollectionViewCell {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    public var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    private var calories: String? {
        didSet {
            self.caloriesLabel.text = calories
        }
    }
    
    private var prep: String? {
        didSet {
            self.prepLabel.text = prep
        }
    }
    
    private var cook: String? {
        didSet {
            self.cookLabel.text = cook
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initHomeRecipesCell() {
        
    }
    
}
