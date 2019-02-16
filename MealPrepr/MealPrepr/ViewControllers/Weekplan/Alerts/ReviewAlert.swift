//
//  ReviewAlert.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/15/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class ReviewAlert: MPViewController, MPLikeControlDelegate {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tasteLikeCtrl: MPLikeControl!
    @IBOutlet weak var difficultyLikeCtrl: MPLikeControl!
    @IBOutlet weak var accuracyLikeCtrl: MPLikeControl!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var recipe: Recipe!
    var alertDelegate: AlertDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReviewAlert()
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        
        let review = Review(reviewer: self.account, reviewDetail: textView.text, recipeGUID: recipe.GUID)
        
        review.save { (saved) in
            if saved {
                self.recipe.reviews.append(review)
                self.alertDelegate?.alertDismissed()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectedChanged(sender: MPLikeControl) {
        if tasteLikeCtrl.hasRating() && difficultyLikeCtrl.hasRating() && accuracyLikeCtrl.hasRating() {
            doneBtn.isEnabled = true
        }
    }
    
    private func setupReviewAlert() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textView.layer.cornerRadius = 4
        textView.tintColor = .black
        tasteLikeCtrl.delegate = self
        difficultyLikeCtrl.delegate = self
        accuracyLikeCtrl.delegate = self
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            textViewBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
}