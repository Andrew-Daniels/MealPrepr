//
//  Utensils.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/11/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let utensilCellIdentifier = "UtensilCell"
public let backToUtensilsIdentifier = "backToUtensils"
private let editUtensilAlertSegueIdentifier = "editUtensil"
private let utensilAlertSegueIdentifier = "UtensilAlert"
private let cancelledEditSegueIdentifier = "cancelledEdit"

class Utensils: MPCreateRecipeChildController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UtensilDelegate {
    
    var utensils: [Utensil]!
    @IBOutlet weak var collectionView: UICollectionView!
    var utensilIndexBeingEdited: IndexPath!
    var isEditingExistingUtensil = false
    var availableUtensils = [Utensil]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper().loadUtensils { (utensils) in
            self.availableUtensils = utensils
        }
        
        if let r = recipe {
            self.utensils = r.utensils
        } else {
            self.utensils = []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return utensils.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: utensilCellIdentifier, for: indexPath) as! UtensilCell
        cell.isSel = true
        let u = utensils[indexPath.row]
        if let photo = u.photo {
           cell.imageView.image = photo
        } else {
            u.delegate = self
        }
        
        cell.titleLabel.text = u.title
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 130.0
        
        let numberOfCells = floor((self.collectionView.frame.size.width - 20) / cellWidth)
        let edgeInsets = (self.collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsets.init(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !readOnly && checkForInternetConnection() {
            performSegue(withIdentifier: editUtensilAlertSegueIdentifier, sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if readOnly {
            return CGSize.init(width: 80, height: 100)
        }
        return CGSize.init(width: 120, height: 130)
    }
    
    func photoDownloaded(sender: Utensil) {
        let firstIndex = utensils.firstIndex { (utensil) -> Bool in
            if utensil.photoPath == utensil.photoPath {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        let index = utensils.startIndex.distance(to: nonNilIndex)
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    @IBAction func backToUtensils(segue: UIStoryboardSegue) {
        switch(segue.identifier) {
            
        case backToUtensilsIdentifier:
            guard let vc = segue.source as? UtensilAlert else { return }
            self.utensils = vc.selectedUtensils
            self.collectionView.reloadData()
            break
        case cancelledEditSegueIdentifier:
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endEditing()
        if segue.identifier == utensilAlertSegueIdentifier ||
            segue.identifier == editUtensilAlertSegueIdentifier {
            if let alertVC = segue.destination as? UtensilAlert {
                alertVC.availableUtensils = availableUtensils
                alertVC.selectedUtensils = utensils
                alertVC.alertDelegate = self
            }
        }
    }
}
