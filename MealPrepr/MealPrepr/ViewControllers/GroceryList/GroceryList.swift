//
//  GroceryList.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/19/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class GroceryList: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var needTableView: UITableView!
    @IBOutlet weak var haveTableView: UITableView!
    
    var recipes: [Recipe]?
    var groceryList: [GroceryItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWithRecipes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == needTableView && section == 0 {
            
            return getGroceryList(type: .Need).count
            
        }
        
        if tableView == haveTableView || section == 1 {
            
            return getGroceryList(type: .Have).count
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: GroceryListCell!
        var item: GroceryItem!
        
        if tableView == needTableView && indexPath.section == 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "Need", for: indexPath) as? GroceryListCell
            item = getGroceryList(type: .Need)[indexPath.row]
            
        }
        
        else if tableView == haveTableView || indexPath.section == 1 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "Have", for: indexPath) as? GroceryListCell
            item = getGroceryList(type: .Have)[indexPath.row]
        
        }
        
        cell.groceryItem = item
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        return isPad ? 1 : 2
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == needTableView && section == 0 {
            
            return "Need"
            
        }
        
        if tableView == haveTableView || section == 1 {
            
            return "Have"
            
        }
        
        return "Need"
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item: GroceryItem!
        
        if tableView == needTableView && indexPath.section == 0 {
            
            item = getGroceryList(type: .Need)[indexPath.row]
            item.status = .Have
            
        }
        
        if tableView == haveTableView || indexPath.section == 1 {
            
            item = getGroceryList(type: .Have)[indexPath.row]
            item.status = .Need
            
        }
        
        tableView.reloadData()
        
    }
    
    private func getGroceryList(type: GroceryItem.GroceryStatus) -> [GroceryItem]{
        
        let list = groceryList.filter { (item) -> Bool in
            return item.status == type
        }
        
        return list.sorted { $0.ingredient.title < $1.ingredient.title }
        
    }
    
    private func setupWithRecipes() {
        
        if let recipes = recipes {
            
            for recipe in recipes {
                
                for ingredient in recipe.ingredients {
                    
                    let item = GroceryItem(ingredient: ingredient)
                    groceryList = item.addGroceryItemToList(groceryList: groceryList)
                    
                }
                
            }
            
            haveTableView?.reloadData()
            needTableView?.reloadData()
            
        }
        
    }

}
