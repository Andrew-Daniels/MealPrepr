//
//  Home.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class Home: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    private var searchController: UISearchController!
    @IBOutlet weak var collectionView: MPCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UIBarButtonItems
        if (account.userLevel == .Guest) {
            let createAccountBtn = UIBarButtonItem(title: "Create Account", style: .done, target: self, action: #selector(createAccountBtnClicked))
            createAccountBtn.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = createAccountBtn
        } else {
            let logoutBtn = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutBtnClicked))
            logoutBtn.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = logoutBtn
        }
        
        //Setup UINavigationBarTitleView
        let imageViewTitle: UIImageView = UIImageView(image: UIImage(named: "Meal-Prepr-Logo"))
        imageViewTitle.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageViewTitle
        imageViewTitle.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        //Setup SearchController
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = .black
            controller.searchBar.returnKeyType = .search
            controller.searchBar.delegate = self
            controller.definesPresentationContext = false
            controller.obscuresBackgroundDuringPresentation = false
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
            self.navigationItem.searchController = controller
            
            return controller
        })()
    }
    
    @objc func createAccountBtnClicked() {
        performSegue(withIdentifier: backToSignUpSegueIdentifier, sender: nil)
    }
    @objc func logoutBtnClicked() {
        performSegue(withIdentifier: backToLoginSegueIdentifier, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecipes", for: indexPath) as! HomeRecipesCell
        cell.title = "Test"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

}
