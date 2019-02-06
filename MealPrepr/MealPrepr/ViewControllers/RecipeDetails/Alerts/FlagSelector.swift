//
//  FlagSelector.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/5/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let cellIdentifier = "flagCell"

class FlagSelector: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flagTypes = ["Inappropriate", "Improper Image", "Not Complete", "Duplicate"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var containerView: UIView!
    var delegate: FlagSelectorDelegate?
    var alertDelegate: AlertDelegate?
    var sender: Any?
    
    override func viewDidLoad() {
        alertDelegate?.alertShown()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertDelegate?.alertDismissed()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SelectorCell
        
        cell.label.text = flagTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Save flag to recipe here
        
        delegate?.flagSelected(reason: flagTypes[indexPath.row])
        
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
