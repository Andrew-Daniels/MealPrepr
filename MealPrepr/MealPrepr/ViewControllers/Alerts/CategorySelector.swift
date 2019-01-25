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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.account.recipeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CategoryCell
        let category = self.account.recipeCategories[indexPath.row]
        cell.categoryLabel.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.account.recipeCategories[indexPath.row]
        delegate?.categorySelected(category: category)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.checkIfTouchesAreInside(touches: touches, ofView: self.containerView) {
            self.dismiss(animated: true, completion: nil)
        }
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
