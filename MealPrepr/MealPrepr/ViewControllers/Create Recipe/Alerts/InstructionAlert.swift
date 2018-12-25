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

class InstructionAlert: MPViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var availableIngredients = [Ingredient]()
    var instruction = Instruction()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var instructionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
    }
    
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
        label.text = availableIngredients[indexPath.row].toString()
        label.sizeToFit()
        var size = label.frame.size
        size.height += 10
        size.width += 6
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! InstructionIngredientCell
        cell.selectedIngredient = !cell.selectedIngredient
        if cell.selectedIngredient {
            let selectedIngredient = availableIngredients[indexPath.row]
            instruction.ingredients.append(selectedIngredient)
        } else {
            let deselectedIngredient = availableIngredients[indexPath.row]
            instruction.ingredients.removeAll { (ingredient) -> Bool in
                if ingredient.toString() == deselectedIngredient.toString() {
                    return true
                }
                return false
            }
        }
    }
    
    @objc func segmentedControlIndexChanged() {
        guard let cookType = Instruction.CookType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        instruction.type = cookType
    }
}
