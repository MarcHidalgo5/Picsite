//
//  Created by Marc Hidalgo on 29/10/22.
//

import UIKit
import PicsiteKit; import PicsiteUI
import BSWInterfaceKit

extension AuthenticationPerformerViewController {
   
   class RegisterViewController: UIViewController, UITextFieldDelegate,
                              AuthenticationPerformerContentViewController {
       
       private let DefaultSpacing: CGFloat = 20
       private let SocialButtonsSpacing: CGFloat = 60
       
       private let usernameTextField = TextField(kind: .username)
       private let emailTextField = TextField(kind: .email)
       private let repeatPasswordTextField = TextField(kind: .password)
       private let passwordTextField = TextField(kind: .password)
       
       private let titleView: UIView = {
           let titleLabel = UILabel()
           titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("login-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 24)
           titleLabel.textAlignment = .center
           return titleLabel
       }()
       
       private let subTitleView: UIView = {
           let titleLabel = UILabel.unlimitedLinesLabel()
           titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("login-subtitle".localized, color: ColorPalette.picsiteTitleColor, forSize: 18)
           titleLabel.textAlignment = .center
           return titleLabel
       }()
       
       private let provider: AuthenticationProviderType
       var observer: AuthenticationObserver
       
       init(provider: AuthenticationProviderType, observer: AuthenticationObserver) {
           self.provider = provider
           self.observer = observer
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func loadView() {
           view = UIView()
           
           let orLabel = UILabel()
           orLabel.attributedText = FontPalette.regularTextStyler.attributedString("login-separetor".localized, color: ColorPalette.picsiteTitleColor, forSize: 16)
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
           
           let stackView = UIStackView(arrangedSubviews: [titleView, subTitleView] + [usernameTextField, emailTextField, passwordTextField, repeatPasswordTextField, separatorStackView, socialButtonContainer])
           stackView.axis = .vertical
           stackView.layoutMargins = [.left: Constants.BigPadding, .bottom: Constants.BigPadding, .right: Constants.BigPadding, .top: 0]
           stackView.isLayoutMarginsRelativeArrangement = true
           stackView.spacing = Constants.Padding
           stackView.alignment = .fill
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
           
           usernameTextField.delegate = self
           emailTextField.delegate = self
           repeatPasswordTextField.delegate = self
           passwordTextField.delegate = self
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           usernameTextField.becomeFirstResponder()
       }
       
       // MARK: IBActions
       
       @objc private func onForgetPasswordTapped() {
           self.view.endEditing(false)
           let vc = ForgotPasswordViewController(provider: self.provider)
           show(vc, sender: nil)
       }
       
       @objc private func onLoginWithGoogle() {
           performBlockingTask(errorMessage: "authentication-google-error".localized, {
               do {
                   try await self.provider.loginUsingGoogle(from: self)
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
           case usernameTextField.textField:
               emailTextField.becomeFirstResponder()
           case emailTextField.textField:
               passwordTextField.becomeFirstResponder()
           case passwordTextField.textField:
               repeatPasswordTextField.resignFirstResponder()
           case repeatPasswordTextField.textField:
               repeatPasswordTextField.resignFirstResponder()
           default:
               break
           }
           return false
       }
       
       //MARK: AuthenticationPerformer
       
       func performAuthentication() async throws {
           try await self.provider.registerUser(displayName: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!)
       }
       
       func validateFields() async throws {
           var errors = ValidationErrors()
           if let username = usernameTextField.text, try await self.provider.isUsernameNotUsed(username: username) {
               errors.insert(.invalidUsername)
           }
           if let email = emailTextField.text, !AuthenticationValidator.validateEmail(email) {
               errors.insert(.invalidEmail)
           }
           if let password = passwordTextField.text, !AuthenticationValidator.validatePassword(password) {
               errors.insert(.invalidPassword)
           }
           if let repeatPassword = repeatPasswordTextField.text, let password = passwordTextField.text, repeatPassword != password {
               errors.insert(.invalidRepeatPassword)
           }
           guard errors.isEmpty else {
               throw errors
           }
       }
       
       func disableAllErrorFields() {
           var animations = [AuthenticationPerformerViewController.ValidationErrorAnimation]()
           animations.append(.init(field: usernameTextField, message: nil))
           animations.append(.init(field: emailTextField, message: nil))
           animations.append(.init(field: passwordTextField, message: nil))
           animations.append(.init(field: repeatPasswordTextField, message: nil))
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

