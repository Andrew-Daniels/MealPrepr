//
//  InstructionCell.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let ingredientButtonCellIdentifier = "IngredientButtonCell"

class InstructionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var delegate: InstructionCellDelegate!
    
    var instruction: Instruction! {
        didSet {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var knownCellHeight: CGFloat! {
        didSet {
            collectionViewHeightConstraint.constant = knownCellHeight
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instruction.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientButtonCellIdentifier, for: indexPath) as! InstructionIngredientCell
        cell.ingredient = instruction.ingredients[indexPath.row]
        cell.selectedIngredient = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = instruction.ingredients[indexPath.row].toString()
        label.sizeToFit()
        var size = label.frame.size
        size.height += 10
        size.width += 6
        return size
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority
        , verticalFittingPriority: verticalFittingPriority)
        
        self.instructionLabel.sizeToFit()
        self.collectionView.layoutIfNeeded()
        
        let contentSize = self.collectionView.contentSize
//        let frameSize = self.collectionView.frame.size
//        let targetSize = targetSize

        if (targetSize.width != contentSize.width) {
            self.collectionView.contentSize.width = self.collectionView.frame.width
            self.collectionView.bounds.size.width = contentSize.width
            self.collectionView.contentSize.height = self.collectionView.bounds.size.height
            self.collectionViewHeightConstraint.constant = contentSize.height
        }

        return CGSize(width: contentSize.width, height: contentSize.height + self.instructionLabel.bounds.size.height + 30)
    }
}
