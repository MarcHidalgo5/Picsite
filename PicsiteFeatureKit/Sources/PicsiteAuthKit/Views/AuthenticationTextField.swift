  //
//  Created by Marc Hidalgo on 11/5/22.
//

import UIKit
import PicsiteUI
import PicsiteKit

extension AuthenticationPerformerViewController {
    
    @objc(AuthenticationTextField)
    class TextField: UIControl, AuthenticationField, UITextFieldDelegate {
        
        enum Kind {
            case name
            case username
            case email
            case password(newPassword: Bool)
        }
        
        let textField = RoundCornersTextField(style: .solid)
        private let titleLable = UILabel.unlimitedLinesLabel()
        private let errorLabel = UILabel.unlimitedLinesLabel()
        
        init(kind: Kind) {
            super.init(frame: .zero)
            switch kind {
            case .name:
                textField.returnKeyType = .next
                textField.textContentType = .name
                textField.keyboardType = .asciiCapable
                textField.autocapitalizationType = .words
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("textField-name-title".localized, color: .gray, forSize: 14)
            case .username:
                textField.returnKeyType = .next
                textField.textContentType = .username
                textField.keyboardType = .asciiCapable
                textField.autocapitalizationType = .none
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("textField-username-title".localized, color: .gray, forSize: 14)
            case .email:
                textField.returnKeyType = .next
                textField.textContentType = .emailAddress
                textField.keyboardType = .emailAddress
                textField.autocapitalizationType = .none
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("textField-email-title".localized, color: .gray, forSize: 14)
            case .password(let isNewPassword):
                textField.returnKeyType = .done
                textField.textContentType = isNewPassword ? .newPassword : .password
                textField.isSecureTextEntry = true
                textField.autocapitalizationType = .none
                titleLable.attributedText = FontPalette.boldTextStyler.attributedString("textField-password-title".localized, color: .gray, forSize: 14)
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
    }
}
