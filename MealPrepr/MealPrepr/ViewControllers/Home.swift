//
//  Home.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class Home: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(account.userLevel == .Guest) {
            let createAccountBtn = UIBarButtonItem(title: "Create Account", style: .done, target: self, action: #selector(createAccountBtnClicked))
            self.navigationItem.leftBarButtonItem = createAccountBtn
        } else {
            let logoutBtn = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutBtnClicked))
            self.navigationItem.rightBarButtonItem = logoutBtn
        }
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.definesPresentationContext = true
            controller.searchBar.returnKeyType = .search
            controller.searchBar.delegate = self
            
            return controller
            
        })()
        
        self.navigationItem.searchController = searchController
    }
    
    @objc func createAccountBtnClicked() {
        performSegue(withIdentifier: backToSignUpSegueIdentifier, sender: nil)
    }
    @objc func logoutBtnClicked() {
        performSegue(withIdentifier: backToLoginSegueIdentifier, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecipes", for: indexPath)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

}
