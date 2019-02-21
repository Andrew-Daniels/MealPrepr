//
//  GroceryList.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/19/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let backToGroceryListUnwindIdentifier = "backToGroceryList"

class GroceryList: MPViewController, UITableViewDelegate, UITableViewDataSource, GroceryListCellDelegate {
    
    @IBOutlet weak var needTableView: UITableView!
    @IBOutlet weak var haveTableView: UITableView!
    
    //var recipes: [Recipe]?
    //var groceryList: [GroceryItem] = []
    var weekplan: WeekplanModel?
    
    private var ingredientAlert: IngredientAlert?
    private var editingIndexRow: Int?
    
    private var ingredientUnits = [String]() {
        didSet {
            if let vc = ingredientAlert {
                vc.ingredientUnits = self.ingredientUnits
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper().loadIngredientUnits { (units) in
            self.ingredientUnits = units
        }
        
        setupWithWeekplan()
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
        cell.delegate = self
        
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
    
    private func getGroceryList(type: GroceryItem.GroceryStatus) -> [GroceryItem] {
        
        if self.weekplan?.groceryList == nil {
            self.weekplan?.groceryList = []
        }
        
        let list = self.weekplan!.groceryList!.filter { (item) -> Bool in
            return item.status == type
        }
        
        return list.sorted { $0.ingredient.title < $1.ingredient.title }
        
    }
    
    private func setupWithWeekplan() {
        
        if let wp = self.weekplan, let recipes = wp.recipes, wp.groceryListNeedsUpdate {
            
            self.weekplan?.groceryList = []
            
            for recipe in recipes {
                
                for ingredient in recipe.ingredients {
                    
                    let item = GroceryItem(ingredient: ingredient)
                    self.weekplan!.groceryList! = item.addGroceryItemToList(groceryList: self.weekplan!.groceryList!)
                    
                }
                
            }
            
            wp.groceryListNeedsUpdate = false
            let _ = wp.save { (saved) in
                //saved
                print("weekplan is saved")
            }
            haveTableView?.reloadData()
            needTableView?.reloadData()
        }
        
    }

    func editGroceryItem(groceryItem: GroceryItem) {
        
        let createRecipe = UIStoryboard(name: "CreateRecipe", bundle: nil)
        guard let vc = createRecipe.instantiateViewController(withIdentifier: "IngredientAlert") as? IngredientAlert else { return }
        vc.ingredient = groceryItem.ingredient
        vc.unwindSegueIdentifier = backToGroceryListUnwindIdentifier
        vc.ingredientUnits = ingredientUnits
        vc.delegate = self
        ingredientAlert = vc
        
        let firstIndex = getGroceryList(type: .Need).firstIndex(where: { (g) -> Bool in
            return g.toString() == groceryItem.toString()
        })
        
        if let nonNilIndex = firstIndex {
            editingIndexRow = getGroceryList(type: .Need).startIndex.distance(to: nonNilIndex)
        }
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func backToGroceryList(segue: UIStoryboardSegue) {
        
    }
    
    override func alertShown() {
        
    }
    
    override func alertDismissed() {
        if editingIndexRow != nil {
            
            let indexPath = IndexPath(row: editingIndexRow!, section: 0)
            needTableView.reloadRows(at: [indexPath], with: .right)
            
        }
        
        editingIndexRow = nil
    }
    
}
