 //
//  Created by Marc Hidalgo on 8/5/22.
//

import UIKit
import PicsiteKit; import PicsiteUI
import BSWInterfaceKit

extension AuthenticationPerformerViewController {
    
    class LoginViewController: UIViewController, UITextFieldDelegate,
                               AuthenticationPerformerContentViewController {
        
        private let DefaultSpacing: CGFloat = 20
        private let SocialButtonsSpacing: CGFloat = 60
        
        private let emailTextField = TitleTextField(kind: .email)
        private let passwordTextField = TitleTextField(kind: .password(newPassword: false))
        
        private let titleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("login-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 22)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let subTitleView: UIView = {
            let titleLabel = UILabel.unlimitedLinesLabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("login-subtitle".localized, color: ColorPalette.picsiteTitleColor, forSize: 16)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let forgotPasswordButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = ColorPalette.picsiteDeepBlueColor
            button.setTitle("login-reset-password-button-action".localized, for: .normal)
            button.titleLabel?.font = FontPalette.mediumTextStyler.fontForSize(14)
            return button
        }()
        
        private let dataSource: AuthenticationDataSourceType
        var observer: AuthenticationObserver
        
        init(dataSource: AuthenticationDataSourceType, observer: AuthenticationObserver) {
            self.dataSource = dataSource
            self.observer = observer
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
            
            let orLabel = UILabel()
            orLabel.attributedText = FontPalette.mediumTextStyler.attributedString("login-title-social".localized, color: .gray, forSize: 14)
            let separator1 = SocialSeparatorView()
            let separator2 = SocialSeparatorView()
            let separatorStackView = UIStackView(arrangedSubviews: [
                separator1,
                orLabel,
                separator2
            ])
            separatorStackView.spacing = DefaultSpacing
            NSLayoutConstraint.activate([
                separator1.widthAnchor.constraint(equalTo: separator2.widthAnchor),
            ])
            
            let loginAppleButton = SocialButtonKind.createSocialButton(kind: .apple)
            let loginInstaButton = SocialButtonKind.createSocialButton(kind: .instagram)
            let loginGoogleButton = SocialButtonKind.createSocialButton(kind: .google)
            
            loginGoogleButton.addTarget(self, action: #selector(onLoginWithGoogle), for: .touchUpInside)
            
            loginInstaButton.addPicsiteShadow()
            loginAppleButton.addPicsiteShadow()
            loginGoogleButton.addPicsiteShadow()
            
            //Hide unused authenticate options
            loginAppleButton.isHidden = true
            loginInstaButton.isHidden = true
            
            let socialLoginStackView = UIStackView(arrangedSubviews: [
                loginGoogleButton,
                loginInstaButton,
                loginAppleButton,
            ])
            socialLoginStackView.axis = .horizontal
            socialLoginStackView.alignment = .fill
            socialLoginStackView.distribution = .fillEqually
            socialLoginStackView.spacing = SocialButtonsSpacing
            
            let socialButtonContainer = UIView()
            socialButtonContainer.addAutolayoutSubview(socialLoginStackView)
            NSLayoutConstraint.activate([
                socialLoginStackView.centerXAnchor.constraint(equalTo: socialButtonContainer.centerXAnchor),
                socialLoginStackView.centerYAnchor.constraint(equalTo: socialButtonContainer.centerYAnchor),
                socialLoginStackView.heightAnchor.constraint(equalTo: socialButtonContainer.heightAnchor),
            ])
            
            let stackView = UIStackView(arrangedSubviews: [titleView, subTitleView] + [emailTextField, passwordTextField, buttonWrapper, separatorStackView, socialButtonContainer])
            stackView.axis = .vertical
            stackView.layoutMargins = [.left: Constants.Padding, .bottom: Constants.BigPadding, .right: Constants.Padding, .top: 0]
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.spacing = Constants.Padding
            stackView.alignment = .fill
            stackView.setCustomSpacing(Constants.SmallPadding, after: titleView)
            stackView.setCustomSpacing(Constants.HugePadding, after: subTitleView)
            view.addSubview(stackView)
            stackView.pinToSuperviewLayoutMargins()
            
            NSLayoutConstraint.activate([
                loginGoogleButton.heightAnchor.constraint(equalTo: loginAppleButton.heightAnchor),
                loginInstaButton.heightAnchor.constraint(equalTo: loginAppleButton.heightAnchor),
                loginAppleButton.heightAnchor.constraint(equalTo: loginAppleButton.heightAnchor)
            ])
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
            passwordTextField.text = "123456789"
            #endif
        }
        
        // MARK: IBActions
        
        @objc private func onForgetPasswordTapped() {
            self.view.endEditing(false)
            let vc = ForgotPasswordViewController(dataSource: self.dataSource)
            show(vc, sender: nil)
        }
        
        @objc private func onLoginWithGoogle() {
            performBlockingTask(errorMessage: "authentication-google-error".localized, {
                do {
                    try await self.dataSource.loginUsingGoogle(from: self)
                    self.observer.didAuthenticate(kind: .google)
                } catch let error {
                    if let socialError = error as? AuthenticationManagerError {
                        if socialError == .userCanceled {
                            return
                        } else {
                            guard let socialError = socialError.errorDescription else { return }
                            self.showErrorAlert(socialError, error: error)
                        }
                    }
                    self.showErrorAlert(error.localizedDescription, error: error)
                }
            })
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
        
        func performAuthentication() async throws {
            try await self.dataSource.loginUserByEmail(email: self.emailTextField.text!, password: self.passwordTextField.text!)
        }
        
        func validateFields() throws {
            var errors = ValidationErrors()
            if let email = emailTextField.text, !AuthenticationValidator.validateEmail(email) {
                errors.insert(.invalidEmail)
            }
            if let password = passwordTextField.text, !AuthenticationValidator.validatePassword(password) {
                errors.insert(.invalidPassword)
            }
            guard errors.isEmpty else {
                throw errors
            }
        }
        
        func disableAllErrorFields() {
            var animations = [AuthenticationPerformerViewController.ValidationErrorAnimation]()
            animations.append(.init(field: emailTextField, message: nil))
            animations.append(.init(field: passwordTextField, message: nil))
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            animator.addAnimations {
                animations.forEach({ (animation) in
                    animation.field.showErrorMessage(message: nil)
                })
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
        
        func animationsFor(errors: ValidationErrors) -> [ValidationErrorAnimation] {
            var animations = [AuthenticationPerformerViewController.ValidationErrorAnimation]()
            animations.append(
                .init(
                    field: emailTextField,
                    message: errors.contains(.invalidEmail) ? "authentication-validation-error-invalid-email".localized : nil
                )
            )

            animations.append(
                .init(
                    field: passwordTextField,
                    message: errors.contains(.invalidPassword) ? "authentication-validation-error-invalid-password".localized : nil
                )
            )
            return animations
        }
    }
}
