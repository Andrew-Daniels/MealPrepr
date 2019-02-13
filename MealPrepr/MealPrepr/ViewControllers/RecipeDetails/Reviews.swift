//
//  Reviews.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/11/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let recipeCellIdentifier = "ReviewCell"

class Reviews: MPViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewContainerHeightConstraint: NSLayoutConstraint!
    
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews = [
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Tom", reviewDetail: "This is my review", recipeGUID: ""),
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Mary", reviewDetail: "This is my review also.", recipeGUID: ""),
            Review(guid: "", reviewerGUID: "", reviewerUsername: "Username1994", reviewDetail: "This is my review, isn't it great?! This review is much longer than all the other ones. I hope this still fits on the screen and allows me to read the whole review. If it doesn't I'll be pretty sad. Won't you?", recipeGUID: "")
        ]
        setupTextView()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        cell.review = review
        return cell
    }
    
    @IBAction func reviewBtnClicked(_ sender: Any) {
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
            
            textView.text = "Say something.."
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            textView.centerVertically()
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
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
        textView.text = "Say something.."
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 20
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 55)
        textView.centerVertically()
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
