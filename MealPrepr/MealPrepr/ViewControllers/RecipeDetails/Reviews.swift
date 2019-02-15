//
//  Reviews.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let recipeCellIdentifier = "ReviewCell"

class Reviews: MPViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ReviewDelegate {
    
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewContainerHeightConstraint: NSLayoutConstraint!
    let placeHolderText = "Say something.."
    var reviewAccountsLoaded = 0
    
    var recipe: Recipe! {
        didSet {
            if recipe.reviews.count == 0 {
                FirebaseHelper().loadReviews(recipe: self.recipe, reviewDelegate: self) { (loaded) in
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
    }
    
    func reviewProfileImageLoaded(sender: Review) {
        let firstIndex = self.recipe.reviews.firstIndex { (review) -> Bool in
            if review.guid == sender.guid {
                return true
            }
            return false
        }
        guard let nonNilIndex = firstIndex else { return }
        let row = recipe.reviews.startIndex.distance(to: nonNilIndex)
        let indexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func reviewAccountLoaded() {
        reviewAccountsLoaded += 1
        if reviewAccountsLoaded == self.recipe.reviewCount {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as! ReviewCell
        let review = recipe.reviews[indexPath.row]
        cell.review = review
        return cell
    }
    
    @IBAction func reviewBtnClicked(_ sender: Any) {
        let review = Review(reviewer: self.account, reviewDetail: self.textView.text, recipeGUID: recipe.GUID)
        review.save { (saved) in
            if saved {
                self.recipe.reviews.append(review)
                self.tableView.reloadData()
                self.resetTextViewText()
            }
        }
    }
    
    func resetTextViewText() {
        
        self.textView.text = self.placeHolderText
        self.textView.textColor = UIColor.lightGray
        self.textView.selectedTextRange = self.textView.textRange(from: self.textView.beginningOfDocument, to: self.textView.beginningOfDocument)
        self.textView.centerVertically()
        self.reviewBtn.isEnabled = false
        self.textViewContainerHeightConstraint.constant = 44.0
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            self.resetTextViewText()
            
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
            
            if text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                reviewBtn.isEnabled = true
            }
            
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let maxHeight: CGFloat = 82.0
        let minHeight: CGFloat = 44.0
        let contentHeight = textView.contentSize.height
        
        if contentHeight <= maxHeight && contentHeight >= minHeight {
            textViewContainerHeightConstraint.constant = contentHeight
        } else if contentHeight < minHeight {
            textViewContainerHeightConstraint.constant = minHeight
        } else if contentHeight > maxHeight {
            textViewContainerHeightConstraint.constant = maxHeight
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupTextView() {
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 20
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 55)
        textView.centerVertically()
        reviewBtn.isEnabled = false
    }

}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
