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

class InstructionAlert: MPViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    enum PickerViewType: Int {
        case Minutes
        case Hours
    }
    
    var availableIngredients = [Ingredient]()
    var instruction: Instruction!
    var minutesPickerViewModel: [String]?
    var hoursPickerViewModel: [String]?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var instructionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hoursPickerView: UIPickerView!
    @IBOutlet weak var minutesPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlertWithInstruction()
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToInstructionsSegueIdentifier, sender: self)
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Instruction goes here...") {
            textView.text = ""
            return
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == minutesPickerView {
            return minutesPickerViewModel?.count ?? 1
        }
        if pickerView == hoursPickerView {
            return hoursPickerViewModel?.count ?? 1
        }
        return 0
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        var pickerType: PickerViewType!
//        
//        if pickerView == minutesPickerView {
//            pickerType = .Minutes
//        }
//        if pickerView == hoursPickerView {
//            pickerType = .Hours
//        }
//        return getPickerViewTitleForRow(pickerType: pickerType, row: row)
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        var hoursInMinutes = 0
        var minutesInMinutes = 0
        
        if pickerView == minutesPickerView {
            minutesInMinutes = Int(minutesPickerViewModel?[row] ?? "0")!
            let hoursSelectedRow = hoursPickerView.selectedRow(inComponent: 0)
            hoursInMinutes = (Int(hoursPickerViewModel?[hoursSelectedRow] ?? "0")! * 60)
        } else if pickerView == hoursPickerView {
            hoursInMinutes = (Int(hoursPickerViewModel?[row] ?? "0")! * 60)
            let minutesSelectedRow = minutesPickerView.selectedRow(inComponent: 0)
            minutesInMinutes = Int(minutesPickerViewModel?[minutesSelectedRow] ?? "0")!
        }
        
        instruction.timeInMinutes = minutesInMinutes + hoursInMinutes
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var pickerType: PickerViewType!
        
        if pickerView == minutesPickerView {
            pickerType = .Minutes
        }
        if pickerView == hoursPickerView {
            pickerType = .Hours
        }
        
        let title = getPickerViewTitleForRow(pickerType: pickerType, row: row)
        return NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func getPickerViewTitleForRow(pickerType: PickerViewType, row: Int) -> String? {
        
        switch(pickerType) {
            
        case .Minutes:
            if minutesPickerViewModel == nil {
                minutesPickerViewModel = [String]()
                for index in 0...60 {
                    minutesPickerViewModel?.append("\(index)")
                }
                minutesPickerView.reloadAllComponents()
            }
            if let model = minutesPickerViewModel, model.count > row {
                return model[row]
            }
        case .Hours:
            if hoursPickerViewModel == nil {
                hoursPickerViewModel = [String]()
                for index in 0...99 {
                    hoursPickerViewModel?.append("\(index)")
                }
                hoursPickerView.reloadAllComponents()
            }
            if let model = hoursPickerViewModel, model.count > row {
                return model[row]
            }
        }
        return String(0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        instruction.instruction = instructionTextView.text
    }
    
    func setupAlertWithInstruction() {
        if self.instruction != nil {
            instructionTextView.text = instruction.instruction
            segmentedControl.selectedSegmentIndex = instruction.type.rawValue
        } else {
            instruction = Instruction()
            instruction.type = .Prep
        }
    }
}
