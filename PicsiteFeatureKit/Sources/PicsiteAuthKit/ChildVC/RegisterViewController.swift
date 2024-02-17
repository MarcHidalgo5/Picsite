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
       
       private let nameTextField = TitleTextField(kind: .name)
       private let usernameTextField = TitleTextField(kind: .username)
       private let emailTextField = TitleTextField(kind: .email)
       private let passwordTextField = TitleTextField(kind: .password(newPassword: true))
       private let legalTermsView = LegalTermsView()
       
       private let titleView: UIView = {
           let titleLabel = UILabel()
           titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("register-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 22)
           titleLabel.textAlignment = .center
           return titleLabel
       }()
       
       private let subTitleView: UIView = {
           let titleLabel = UILabel.unlimitedLinesLabel()
           titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("register-subtitle".localized, color: ColorPalette.picsiteTitleColor, forSize: 16)
           titleLabel.textAlignment = .center
           return titleLabel
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
           
           let orLabel = UILabel()
           orLabel.attributedText = FontPalette.mediumTextStyler.attributedString("register-title-social".localized, color: .gray, forSize: 14)
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
           
           let stackView = UIStackView(arrangedSubviews: [titleView, subTitleView] + [nameTextField ,usernameTextField, emailTextField, passwordTextField, legalTermsView, separatorStackView, socialButtonContainer])
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
           
           nameTextField.delegate = self
           usernameTextField.delegate = self
           emailTextField.delegate = self
           passwordTextField.delegate = self
           // We need this to disable password autofill on simulator because it breaks the UITests on iOS 16
           #if targetEnvironment(simulator)
           passwordTextField.textField.textContentType = .oneTimeCode
           #endif
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           nameTextField.becomeFirstResponder()
       }
       
       // MARK: IBActions
       
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
           case nameTextField.textField:
               usernameTextField.becomeFirstResponder()
           case usernameTextField.textField:
               emailTextField.becomeFirstResponder()
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
           try await self.dataSource.registerUser(username: self.usernameTextField.text!, fullName: self.nameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!)
       }
       
       func validateFields() throws {
           var errors = ValidationErrors()
           if let username = usernameTextField.text, !AuthenticationValidator.validatUsername(username) {
               errors.insert(.invalidUsername)
           }
           if let name = nameTextField.text, !AuthenticationValidator.validateName(name) {
               errors.insert(.invalidName)
           }
           if let email = emailTextField.text, !AuthenticationValidator.validateEmail(email) {
               errors.insert(.invalidEmail)
           }
           if let password = passwordTextField.text, !AuthenticationValidator.validatePassword(password) {
               errors.insert(.invalidPassword)
           }
           if !legalTermsView.termsAndConditionsAccepted {
               errors.insert(.didNotAcceptTC)
           }
           guard errors.isEmpty else {
               throw errors
           }
       }
       
       func disableAllErrorFields() {
           var animations = [AuthenticationPerformerViewController.ValidationErrorAnimation]()
           animations.append(.init(field: nameTextField, message: nil))
           animations.append(.init(field: usernameTextField, message: nil))
           animations.append(.init(field: emailTextField, message: nil))
           animations.append(.init(field: passwordTextField, message: nil))
           animations.append(.init(field: legalTermsView.termsAndConditionsView, message: nil))
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
                   field: nameTextField,
                   message: errors.contains(.invalidName) ? "authentication-validation-error-invalid-name".localized : nil
               )
           )
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
           animations.append(
               .init(
                   field: usernameTextField,
                   message: errors.contains(.invalidUsername) ? "authentication-validation-error-invalid-username-lenght".localized : nil
               )
           )
           animations.append(
               .init(
                   field: legalTermsView.termsAndConditionsView,
                   message: errors.contains(.didNotAcceptTC) ? "authentication-validation-error-invalid-t&c".localized : nil
               )
           )
           return animations
       }
   }
}

