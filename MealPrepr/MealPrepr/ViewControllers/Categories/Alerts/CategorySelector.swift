//
//  CategorySelector.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/15/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let popoverSegueIdentifier = "categorySelectorPopover"
private let selectorSegueIdentifier = "categorySelectorModal"
private let cellIdentifier = "CategoryCell"

class CategorySelector: MPViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var delegate: CategorySelectorDelegate?
    var alertDelegate: AlertDelegate?
    var sender: Any?
    var recipe: Recipe?
    var showsAll = false
    
    override func viewDidLoad() {
        alertDelegate?.alertShown()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertDelegate?.alertDismissed()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsAll ? self.account.categories.count + 1 : self.account.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SelectorCell
        
        var category = "All"
        
        if !showsAll {
            category = self.account.categories[indexPath.row]
            let recipeCat = recipe?.getCategory(account: self.account, completionHandler: { (category) in
                
            })
            cell.cancelImageView?.isHidden = !(recipeCat != nil && recipeCat == category)
            cell.accessoryType = cell.cancelImageView != nil && cell.cancelImageView.isHidden ? .disclosureIndicator : .none
        } else {
            if indexPath.row > 0 {
                category = self.account.recipeCategories[indexPath.row - 1]
            }
        }
        
        cell.label.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category: String? = "All"
        
        if !showsAll {
            category = self.account.recipeCategories[indexPath.row]
            
            if let r = recipe, r.getCategory() != category {
                r.setCategory(category: category)
            } else if let r = recipe {
                r.setCategory(category: nil)
                category = nil
            }
        } else {
            if indexPath.row > 0 {
                category = self.account.recipeCategories[indexPath.row - 1]
            }
        }
        
        delegate?.categorySelected(category: category)
        dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.checkIfTouchesAreInside(touches: touches, ofView: self.containerView.superview!) {
            dismiss()
        }
    }
    
    private func dismiss() {
        if let sender = self.sender as? UIButton {
            sender.isSelected = false
        }
        self.account.finishedViewingCategories()
        self.dismiss(animated: true, completion: nil)
    }

}
