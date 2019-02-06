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
    var showsAll = false
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        alertDelegate?.alertShown()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertDelegate?.alertDismissed()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsAll ? self.account.recipeCategories.count + 1 : self.account.recipeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SelectorCell
        
        var category = "All"
        
        if !showsAll {
            category = self.account.recipeCategories[indexPath.row]
        } else {
            if indexPath.row > 0 {
                category = self.account.recipeCategories[indexPath.row - 1]
            }
        }
        
        cell.label.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category = "All"
        
        if !showsAll {
            category = self.account.recipeCategories[indexPath.row]
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
