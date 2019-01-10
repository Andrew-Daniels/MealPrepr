//
//  UtensilAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

private let utensilCellIdentifier = "utensilCell"

class UtensilAlert: MPViewController, MPTextFieldDelegate, UtensilDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var availableUtensils: [Utensil]!
    var selectedUtensils = [Utensil]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlertWithUtensil()
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToUtensilsIdentifier, sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableUtensils.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: utensilCellIdentifier, for: indexPath) as! UtensilCell
        let u = availableUtensils[indexPath.row]
        if let image = u.photo {
            cell.imageView.image = image
        } else {
            availableUtensils[indexPath.row].delegate = self
        }
        
        if selectedUtensils.contains(where: { (utensil) -> Bool in
            if utensil.photoPath == u.photoPath {
                return true
            }
            return false
        }) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let u = availableUtensils[indexPath.row]
        if selectedUtensils.contains(where: { (utensil) -> Bool in
            if utensil.photoPath == u.photoPath {
                return true
            }
            return false
        }) {
            selectedUtensils.removeAll { (utensil) -> Bool in
                if utensil.photoPath == u.photoPath {
                    return true
                }
                return false
            }
            self.collectionView.reloadItems(at: [indexPath])
        } else {
            selectedUtensils.append(u)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        self.collectionViewCellWidth = 100.0
//        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
//    }
    
    func photoDownloaded(sender: Utensil) {
        let firstIndex = availableUtensils.firstIndex { (utensil) -> Bool in
            if utensil.photoPath == utensil.photoPath {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        let index = availableUtensils.startIndex.distance(to: nonNilIndex)
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        let _ = textField.resignFirstResponder()
    }
    
    func setupAlertWithUtensil() {
        
    }
}

