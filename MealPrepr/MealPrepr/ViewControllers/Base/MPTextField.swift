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
            if let text = self._text, text.count > 0 {
                self.textFieldLabel.isHidden = false
            } else {
                self.textFieldLabel.isHidden = true
            }
        }
    }
    
    public var hasError: Bool {
        get { return self._hasError }
    }
    
    public var text: String? {
        get { return self.textField.text }
        set { self._text = newValue }
    }
    
    @IBInspectable
    public var placeholderText: String? {
        didSet {
            if let placeholder = self.placeholderText {
                let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderTextColor ?? UIColor.lightGray])
                self.textField.attributedPlaceholder = attributedPlaceholder
                self.textFieldLabel.text = placeholder
            }
        }
    }
    
    @IBInspectable
    public var isNumberField: Bool = false {
        didSet {
            if isNumberField {
                self.textField.keyboardType = .decimalPad
            } else {
                self.textField.keyboardType = .default
            }
        }
    }
    
    @IBInspectable
    public var errorTextColor: UIColor? {
        didSet {
            self.errorLabel.textColor = self.errorTextColor
        }
    }
    
    @IBInspectable
    public var textFieldTextColor: UIColor? {
        didSet {
            self.textField.textColor = self.textFieldTextColor
            self.borderColor = self.textFieldTextColor?.cgColor
            self.textFieldLabel.textColor = self.textFieldTextColor
        }
    }
    
    @IBInspectable
    public var placeHolderTextColor: UIColor? {
        didSet {
            self.textField.attributedPlaceholder = NSAttributedString(string: self.placeholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderTextColor ?? UIColor.lightGray])
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
    var textFieldLabel: UILabel = UILabel()
    var delegate: MPTextFieldDelegate?
    var authFieldType: ErrorHelper.AuthFieldType!
    
    private var _hasError: Bool = false
    private var borderColor: CGColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initMPTextField()
    }
    
    public func setError(errorMsg: String?) {
        if let errorMsg = errorMsg {
            self.errorLabel.text = errorMsg
            _hasError = true;
            animateError(numberOfShakes: 2.0, revert: true)
        }
    }
    
    public func setAuthError(errorMsg: String?, authFieldType: ErrorHelper.AuthFieldType?) {
        if let _authFieldType = self.authFieldType, _authFieldType == authFieldType {
            setError(errorMsg: errorMsg)
        }
    }
    
    public func notifyOfError() {
        if (self._hasError) {
            self.animateError(numberOfShakes: 2.0, revert: true)
        }
    }
    
    private func animateError(numberOfShakes shakes: Float, revert: Bool) {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.textField.center.x - 10, y: self.textField.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.textField.center.x + 10, y: self.textField.center.y))
        self.textField.layer.add(shake, forKey: "position")
    }
    
    private func removeError() {
        errorLabel.text = ""
        _hasError = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (self.authFieldType != .Username) {
            self.removeError()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = self.text, text.count > 1 {
            if authFieldType == .Username {
                FirebaseHelper().checkUsernameAvailability(username: self.text) { (available) in
                    if (!available) {
                        self.setError(errorMsg: ErrorHelper.getErrorMsg(errorKey: .UsernameTaken))
                    } else {
                        self.removeError()
                    }
                }
            }
        }
        else if let text = self.text, text.count > 0 {
            self.textFieldLabel.isHidden = false
        } else {
            self.textFieldLabel.isHidden = true
        }
        self.delegate?.mpTextFieldTextDidChange(text: textField.text)
    }
    
    private func initMPTextField() {
        //Add Textfield and ErrorLabel to MPTextField
        self.addSubview(textField)
        self.addSubview(errorLabel)
        self.addSubview(textFieldLabel)
        
        self.backgroundColor = .clear
        
        //Setup TextField
        self.textField.borderStyle = .none
        self.textField.delegate = self
        self.textField.textColor = UIColor.white
        self.textField.returnKeyType = .next
        self.textField.clearButtonMode = .whileEditing
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.textField.minimumFontSize = 10
        self.textField.adjustsFontSizeToFitWidth = true
        
        //Setup errorLabel
        var font = UIFont(name: "Helvetica", size: 12.0)
        self.errorLabel.font = font
        self.errorLabel.textColor = UIColor.white
        self.errorLabel.numberOfLines = 2
        
        //Setup textfield label
        font = UIFont(name: "Helvetica-Bold", size: 14.0)
        self.textFieldLabel.font = font
        self.textFieldLabel.textColor = UIColor.white
        self.textFieldLabel.isHidden = true
        
        //Setup constraints for TextField, ErrorLabel, and TextFieldLabel
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var topConstraint = (NSLayoutConstraint(item: textFieldLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        var leadingConstraint = (NSLayoutConstraint(item: textFieldLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        var trailingConstraint = (NSLayoutConstraint(item: textFieldLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        topConstraint = (NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: textFieldLabel, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        leadingConstraint = (NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        trailingConstraint = (NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        topConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        leadingConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1.0, constant: 0.0))
        trailingConstraint = (NSLayoutConstraint(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        if let setColor = self.borderColor {
            border.borderColor = setColor
        }
        else
        {
            border.borderColor = UIColor.white.cgColor
        }
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
        if (!self.textField.isFirstResponder && self.textField.canBecomeFirstResponder) {
            self.textField.becomeFirstResponder()
            return true
        }
        return false
    }
}



