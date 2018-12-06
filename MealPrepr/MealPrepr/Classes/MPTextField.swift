//
//  MPTextField.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/4/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MPTextField: UIControl, UITextFieldDelegate {

    private var _text: String? {
        didSet {
            self.textField.text = self._text
        }
    }
    
    public var hasError: Bool {
        get { return self._hasError }
    }
    
    private var _hasError: Bool = false
    
    public var text: String? {
        get { return self.textField.text }
        set { self._text = text }
    }
    
    @IBInspectable
    public var placeholderText: String? {
        didSet {
            if let placeholder = self.placeholderText {
                self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }
        }
    }
    
    @IBInspectable
    public var passwordField: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = passwordField
            self.textField.returnKeyType = .done
        }
    }
    
    var textField: UITextField = UITextField()
    var errorLabel: UILabel = UILabel()
    var delegate: MPTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initMPTextField()
    }
    
    public func setError(errorMsg: String?) {
        if let errorMsg = errorMsg {
            errorLabel.text = errorMsg
            _hasError = true;
            setError(numberOfShakes: 2.0, revert: true)
        }
    }
    
    private func removeError() {
        errorLabel.text = ""
        _hasError = false
    }
    
    private func setError(numberOfShakes shakes: Float, revert: Bool) {

        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.textField.center.x - 10, y: self.textField.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.textField.center.x + 10, y: self.textField.center.y))
        self.textField.layer.add(shake, forKey: "position")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.removeError()
        return true
    }
    
    private func initMPTextField() {
        self.addSubview(textField)
        self.addSubview(errorLabel)
        
        self.textField.borderStyle = .none
        self.textField.delegate = self
        self.textField.textColor = UIColor.white
        self.textField.returnKeyType = .next
        
        let font = UIFont(name: "Helvetica", size: 12.0)
        self.errorLabel.font = font
        self.errorLabel.textColor = UIColor.white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var topConstraint = (NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        var leadingConstraint = (NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        var trailingConstraint = (NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        topConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        leadingConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0.0))
        trailingConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
    }
    
    public func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.textField.frame.size.height - borderWidth, width: self.textField.frame.size.width, height: self.textField.frame.size.height)
        border.borderWidth = borderWidth
        self.textField.layer.addSublayer(border)
        self.textField.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.useUnderline()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.delegate {
            delegate.mpTextFieldShouldReturn(textField: self)
        }
        return true;
    }
    override func resignFirstResponder() -> Bool {
        if (self.textField.isFirstResponder) {
            self.textField.resignFirstResponder()
            return true
        }
        return false
    }
    override func becomeFirstResponder() -> Bool {
        if (!self.textField.isFirstResponder) {
            self.textField.becomeFirstResponder()
            return true
        }
        return false
    }
}



