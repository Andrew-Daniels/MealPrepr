//
//  InstructionAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/13/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

private let ingredientButtonCellIdentifier = "IngredientButtons"

class InstructionAlert: MPViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var availableIngredients = [Ingredient]()
    var instruction: String!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var instructionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToUtensilsIdentifier, sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientButtonCellIdentifier, for: indexPath) as! InstructionIngredientCell
        cell.ingredient = availableIngredients[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = availableIngredients[indexPath.row].title
        label.sizeToFit()
        var size = label.frame.size
        size.height += 10
        size.width += 6
        return size
    }
}
