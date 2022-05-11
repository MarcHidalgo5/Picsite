  //
//  Created by Marc Hidalgo on 11/5/22.
//

import UIKit
import PicsiteUI

extension AuthenticationPerformerViewController {
    
    @objc(AuthenticationTextField)
    class TextField: UIControl, AuthenticationField, UITextFieldDelegate {
        
        enum Kind {
            case name
            case username
            case email
            case password
            case newPassword
        }
        
        let textField = RoundCornersTextField(style: .solid)
        private let titleLable = UILabel.unlimitedLinesLabel()
        private let errorLabel = UILabel.unlimitedLinesLabel()
        
        init(kind: Kind) {
            super.init(frame: .zero)
            switch kind {
            case .name:
                textField.returnKeyType = .next
                textField.placeholder = "Your name".localized
                textField.textContentType = .name
                textField.keyboardType = .asciiCapable
                textField.autocapitalizationType = .words
            case .username:
                textField.returnKeyType = .done
                textField.placeholder = "Your username".localized
                textField.textContentType = .username
                textField.keyboardType = .asciiCapableNumberPad
                textField.autocapitalizationType = .none
            case .email:
                textField.returnKeyType = .next
                textField.attributedPlaceholder = FontPalette.mediumTextStyler.attributedString("Enter your email".localized, color: .gray, forSize: 14)
                textField.textContentType = .emailAddress
                textField.keyboardType = .emailAddress
                textField.autocapitalizationType = .none
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("Email", color: .gray, forSize: 14)
            case .password, .newPassword:
                textField.attributedPlaceholder = FontPalette.mediumTextStyler.attributedString("Enter your password".localized, color: .gray, forSize: 14)
                textField.returnKeyType = .done
                textField.textContentType = kind == .newPassword ? .newPassword : .password
                textField.isSecureTextEntry = true
                textField.autocapitalizationType = .none
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("Password", color: .gray, forSize: 14)
            }
            
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            let stackView = UIStackView(arrangedSubviews: [titleLable, textField, errorLabel])
            stackView.axis = .vertical
            stackView.spacing = AuthenticationPerformerViewController.Constants.SmallPadding
            addAutolayoutSubview(stackView)
            stackView.pinToSuperview()
            
            showErrorMessage(message: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: UITextFieldDelegate
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            guard textField.textContentType != .name else { return }
            let text = textField.text ?? ""
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            textField.text = trimmedText
        }
        
        //MARK: AuthenticationField
        
        func showErrorMessage(message: NSAttributedString?) {
            guard let message = message else {
                errorLabel.attributedText = nil
                errorLabel.isHidden = true
                return
            }
            errorLabel.attributedText = message
            errorLabel.isHidden = false
        }
        
        //MARK: UITextField overrides
        
        open var text: String? {
            get {
                return textField.text
            }
            set {
                textField.text = newValue
            }
        }
        
        weak open var delegate: UITextFieldDelegate? {
            get {
                return textField.delegate
            }
            set {
                textField.delegate = newValue
            }
        }
        
        //MARK: UIResponder overrides
        
        override var canBecomeFirstResponder: Bool {
            return textField.canBecomeFirstResponder
        }
        
        override var canResignFirstResponder: Bool  {
            return textField.canResignFirstResponder
        }
        
        override var isFirstResponder: Bool {
            return textField.isFirstResponder
        }
        
        @discardableResult
        override func resignFirstResponder() -> Bool {
            return textField.resignFirstResponder()
        }
        
        @discardableResult
        override func becomeFirstResponder() -> Bool {
            return textField.becomeFirstResponder()
        }
        
        //MARK: UIControl overrides
        
        override var isEnabled: Bool {
            set {
                textField.isEnabled = newValue
            }
            get {
                return textField.isEnabled
            }
        }
        
        override var isSelected: Bool {
            set {
                textField.isSelected = newValue
            }
            get {
                return textField.isSelected
            }
        }
        
        override var isHighlighted: Bool  {
            set {
                textField.isHighlighted = newValue
            }
            get {
                return textField.isHighlighted
            }
        }
        
        override var contentVerticalAlignment: UIControl.ContentVerticalAlignment  {
            set {
                textField.contentVerticalAlignment = newValue
            }
            get {
                return textField.contentVerticalAlignment
            }
        }
        
        override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment  {
            set {
                textField.contentHorizontalAlignment = newValue
            }
            get {
                return textField.contentHorizontalAlignment
            }
        }
        
        override var effectiveContentHorizontalAlignment: UIControl.ContentHorizontalAlignment  {
            return textField.effectiveContentHorizontalAlignment
        }
        
        override var state: UIControl.State { return textField.state }
        
        override var isTracking: Bool { return textField.isTracking }
        
        override var isTouchInside: Bool { return textField.isTouchInside }
        
        
        override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool  {
            return textField.beginTracking(touch, with: event)
        }
        
        override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            return textField.continueTracking(touch, with: event)
        }
        
        override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
            return textField.endTracking(touch, with: event)
        }
        
        override func cancelTracking(with event: UIEvent?) {
            return textField.cancelTracking(with: event)
        }
        
        override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
            return textField.addTarget(target, action: action, for: controlEvents)
        }
        
        override func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
            return textField.removeTarget(target, action: action, for: controlEvents)
        }
        
        override var allTargets: Set<AnyHashable> { return textField.allTargets }
        
        override var allControlEvents: UIControl.Event { return textField.allControlEvents }
        
        override func actions(forTarget target: Any?, forControlEvent controlEvent: UIControl.Event) -> [String]? {
            return textField.actions(forTarget: target, forControlEvent: controlEvent)
        }
        
        override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
            return textField.sendAction(action, to: target, for: event)
        }
        
        override func sendActions(for controlEvents: UIControl.Event) {
            return textField.sendActions(for: controlEvents)
        }
    }
}
