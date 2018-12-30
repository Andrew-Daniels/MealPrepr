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
            collectionView.reloadData()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let collectionViewSize = collectionView.collectionViewLayout.collectionViewContentSize
        if (knownCellHeight == nil && collectionViewSize.height != 0)
            || (knownCellHeight != nil && knownCellHeight != collectionViewSize.height) {
            delegate.instructionCellCollectionViewContentSizeSet(for: self, toSize: collectionViewSize)
        }
    }
}
