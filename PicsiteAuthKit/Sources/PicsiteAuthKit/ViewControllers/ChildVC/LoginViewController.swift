 //
//  Created by Marc Hidalgo on 8/5/22.
//

import UIKit
import PicsiteKit; import PicsiteUI

extension AuthenticationPerformerViewController {
    
    class LoginViewController: UIViewController, UITextFieldDelegate,
                               AuthenticationPerformerContentViewController {
        
        private let emailTextField = TextField(kind: .email)
        private let passwordTextField = TextField(kind: .password)
        private let titleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Welcome back", color: ColorPalette.picsiteTitleColor, forSize: 24)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let subTitleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Hello there, log in to continue!", color: ColorPalette.picsiteTitleColor, forSize: 20)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let forgotPasswordButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = ColorPalette.picsiteDeepBlueColor
            button.setTitle("Forgot password?", for: .normal)
            button.titleLabel?.font = FontPalette.mediumTextStyler.fontForSize(14)
            return button
        }()
        
        private let provider: AuthenticationProviderType
        
        init(provider: AuthenticationProviderType) {
            self.provider = provider
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = UIView()
        
            let buttonWrapper: UIView = {
                let view = UIView()
                // This view is to keep forgotPasswordButton
                // left aligned inside a .fill & .fill stackView
                view.addAutolayoutSubview(forgotPasswordButton)
                NSLayoutConstraint.activate([
                    forgotPasswordButton.topAnchor.constraint(equalTo: view.topAnchor),
                    forgotPasswordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                ])
                return view
            }()
            
            let stackView = UIStackView(arrangedSubviews: [titleView, subTitleView] + [emailTextField, passwordTextField, buttonWrapper])
            stackView.axis = .vertical
            stackView.layoutMargins = [.left: Constants.BigPadding, .bottom: Constants.BigPadding, .right: Constants.BigPadding, .top: 0]
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.spacing = Constants.Padding
            stackView.setCustomSpacing(Constants.HugePadding, after: subTitleView)
            view.addSubview(stackView)
            stackView.pinToSuperviewLayoutMargins()
            
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            emailTextField.delegate = self
            passwordTextField.delegate = self
            forgotPasswordButton.addTarget(self, action: #selector(onForgetPasswordTapped), for: .touchUpInside)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            emailTextField.becomeFirstResponder()
            
            #if DEBUG
            let isRunningTests = UIApplication.shared.isRunningTests
            guard !isRunningTests else {
                return
            }
            emailTextField.text = "marchidalgo@icloud.com"
            passwordTextField.text = "12345678"
            #endif
        }
        
        // MARK: IBActions
        
        @objc private func onForgetPasswordTapped() {
        }

        // MARK: UITextFieldDelegate
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            switch textField {
            case emailTextField.textField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField.textField:
                passwordTextField.resignFirstResponder()
            default:
                break
            }
            return false
        }
        
        //MARK: AuthenticationPerformer
        
        func performAuthentication() async throws -> (String) {
            fatalError()
        }
        
        func validateFields() throws {
            fatalError()
        }
        
        func animationsFor(errors: AuthenticationPerformerViewController.ValidationErrors) -> [AuthenticationPerformerViewController.ValidationErrorAnimation] {
            fatalError()
        }
        
        var authenticationName: String? {
            get {
                nil
            } set {
                //Nothing
            }
        }
        
        var authenticationEmail: String? {
            get {
                emailTextField.text
            } set {
                emailTextField.text = newValue
            }
        }
    }
}
