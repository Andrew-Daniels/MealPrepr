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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var roundedUIView: RoundedUIView!
    var availableUtensils: [Utensil]!
    var filteredUtensils: [Utensil]!
    var selectedUtensils = [Utensil]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlertWithUtensil()
        self.searchBar.showsCancelButton = true
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        
        
        
        self.view.endEditing(true)
        performSegue(withIdentifier: backToUtensilsIdentifier, sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let f = self.filteredUtensils {
            return f.count
        }
        return availableUtensils.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: utensilCellIdentifier, for: indexPath) as! UtensilCell
        
        var u = Utensil()
        if let f = self.filteredUtensils {
            u = f[indexPath.row]
        } else {
            u = availableUtensils[indexPath.row]
        }
        
        cell.titleLabel.text = u.title
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
            cell.isSel = true
        } else {
            cell.isSel = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var u = Utensil()
        if let f = self.filteredUtensils {
            u = f[indexPath.row]
        } else {
            u = availableUtensils[indexPath.row]
        }
        
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
        
        self.endEditing()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredUtensils = nil
        refreshCollection()
        self.endEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredUtensils = nil
            refreshCollection()
            return
        }
        filteredUtensils = availableUtensils.filter({ (utensil) -> Bool in
            if utensil.title.contains(searchText) {
                return true
            }
            return false
        })
        refreshCollection()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
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
    
    func refreshCollection() {
        self.collectionView.reloadData()
    }
    
    override func endEditing() {
        super.endEditing()
        self.searchBar.resignFirstResponder()
    }
}

