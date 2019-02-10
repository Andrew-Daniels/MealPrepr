//
//  Weekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/2/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let weekplanCellIdentifier = "weekplanCell"

class Weekplan: MPViewController, UITableViewDelegate, UITableViewDataSource, RecipeDelegate {
    
    @IBOutlet weak var editWeekplanBtn: UIButton!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var weekplanNotExistView: UIView!
    @IBOutlet weak var weekplanExistsView: UIView!
    private var weekplan: WeekplanModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper().loadWeekplan(account: self.account) { (weekplan) in
            self.weekplan = weekplan
            self.setupWeekplan()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = checkForGuestAccount()
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
        
        self.showRecipeDetails(recipe: recipe)
    }
    
    @IBAction func addBarBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func shoppingCartBtnClicked(_ sender: Any) {
        
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
        } else {
            //Show create weekplan message
            weekplanExistsView.isHidden = true
            weekplanNotExistView.isHidden = false
        }
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
    
}
