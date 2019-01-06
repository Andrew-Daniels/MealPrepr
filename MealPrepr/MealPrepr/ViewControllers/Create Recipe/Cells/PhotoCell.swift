//
//  PhotoCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/12/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        delegate?.deleteBtnPressed(sender: self)
    }
}
