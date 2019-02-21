//
//  Weekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/2/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let weekplanCellIdentifier = "weekplanCell"
private let editWeekplanSegueIdentifier = "editWeekplan"

class Weekplan: MPViewController, UITableViewDelegate, UITableViewDataSource, RecipeDelegate {
    
    @IBOutlet weak var editWeekplanBtn: UIButton!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var weekplanNotExistView: UIView!
    @IBOutlet weak var weekplanExistsView: UIView!
    private var weekplan: WeekplanModel?
    private var editBtn: UIBarButtonItem?
    private var groceryListBtn: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.account.userLevel != .Guest {
            FirebaseHelper().loadWeekplan(account: self.account) { (weekplan) in
                self.weekplan = weekplan
                self.setupWeekplan()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = checkForGuestAccount()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekplan?.recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weekplanCellIdentifier, for: indexPath) as! WeekplanRecipeCell
        let recipe = weekplan?.recipes?[indexPath.row]
        recipe?.recipeDelegate = self
        
        cell.recipe = recipe
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recipe = weekplan?.recipes?[indexPath.row] else { return }
        
        self.showRecipeDetails(recipe: recipe, weekplan: weekplan)
    }
    
    @IBAction func addBarBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Override Weekplan", message: "If you continue, you will override the current weekplan you have.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "New", style: .default) { (action) in
            self.performSegue(withIdentifier: "addWeekplan", sender: sender)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "editWeekplan", sender: sender)
    }
    
    @IBAction func shoppingCartBtnClicked(_ sender: Any) {
        
        let groceryList = UIStoryboard(name: "GroceryList", bundle: nil)
        guard let vc = groceryList.instantiateViewController(withIdentifier: "GroceryList") as? GroceryList else { return }
        vc.weekplan = self.weekplan
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func weekplanExists() -> Bool {
        return weekplan != nil
    }
    
    private func setupWeekplan() {
        if weekplanExists() {
            //Show weekplan
            tableView.reloadData()
            weekplanExistsView.isHidden = false
            weekplanNotExistView.isHidden = true
            setupBarButtons()
        } else {
            //Show create weekplan message
            weekplanExistsView.isHidden = true
            weekplanNotExistView.isHidden = false
        }
    }
    
    private func setupBarButtons() {
        
        if editBtn == nil {
            
            editBtn = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(editBtnClicked(_:)))
            editBtn?.image = UIImage(named: "Edit_Black")?.withRenderingMode(.alwaysTemplate)
            editBtn?.tintColor = UIColor.white
            
            self.navigationItem.rightBarButtonItems?.append(editBtn!)
            
        }
        
        
//        groceryListBtn = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(shoppingCartBtnClicked(_:)))
//        groceryListBtn?.image = UIImage(named: "ShoppingCart_Black")?.withRenderingMode(.alwaysTemplate)
//        groceryListBtn?.tintColor = UIColor.white
        
        
        //self.navigationItem.leftBarButtonItem = groceryListBtn!
    }

    @IBAction func backToWeekplan(segue: UIStoryboardSegue) {
        if let vc = segue.source as? CreateWeekplan {
            self.weekplan = vc.weekplan
            self.setupWeekplan()
        }
    }
    
    func photoDownloaded(sender: Recipe) {
        let firstIndex = self.weekplan?.recipes?.firstIndex { (recipe) -> Bool in
            if recipe.GUID == sender.GUID {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        guard let row = self.weekplan?.recipes?.startIndex.distance(to: nonNilIndex) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func photoDownloaded(photoPath index: Int) {
        
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == editWeekplanSegueIdentifier {
            if let vc = segue.destination as? CreateWeekplan, let wp = self.weekplan {
                vc.navigationItem.title = "Editing Weekplan"
                vc.weekplan.recipes = wp.recipes
                vc.weekplan.dateCreated = wp.dateCreated
                vc.weekplan.GUID = wp.GUID
                vc.weekplan.owner = wp.owner
            }
        }
    }
    
}
