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
        
        private let emailTextField = TextField(kind: .email)
        private let passwordTextField = TextField(kind: .password)
        
        private let titleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Welcome back".localized, color: ColorPalette.picsiteTitleColor, forSize: 24)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let subTitleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Hello there, log in to continue!".localized, color: ColorPalette.picsiteTitleColor, forSize: 20)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let forgotPasswordButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = ColorPalette.picsiteDeepBlueColor
            button.setTitle("Don't remember the password?".localized, for: .normal)
            button.titleLabel?.font = FontPalette.mediumTextStyler.fontForSize(14)
            return button
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
            orLabel.attributedText = FontPalette.regularTextStyler.attributedString("or".localized, color: ColorPalette.picsiteTitleColor, forSize: 16)
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
            
            let loginAppleButton = createSocialButton(kind: .apple)
            let loginInstaButton = createSocialButton(kind: .instagram)
            let loginGoogleButton = createSocialButton(kind: .google)
            
//            loginAppleButton.addTarget(self, action: #selector(onLoginWithApple), for: .touchUpInside)
//            loginFBButton.addTarget(self, action: #selector(onLoginWithFacebook), for: .touchUpInside)
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
        
        @objc private func onForgetPasswordTapped() { }
        
        @objc private func onLoginWithGoogle() {
            performBlockingTask(errorMessage: "authentication-google-error".localized, {
                let user = try await self.provider.loginUsingGoogle(from: self)
                self.observer.didAuthenticate(userID: user.uid, kind: .google)
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

extension AuthenticationPerformerViewController.LoginViewController {
    
    public enum SocialButtonKind {
        case apple, instagram, google
        
        public var image: UIImage {
            switch self {
            case .apple:
                return UIImage(systemName: "applelogo")!.withRenderingMode(.alwaysTemplate)
            case .instagram:
                return UIImage(named: "instagram-icon")!
            case .google:
                return UIImage(named: "google-icon")!
            }
        }
        
        public var tintColor: UIColor? {
            switch self {
            case .apple: return .black
            default: return nil
            }
        }
        
        public var backgroundColor: UIColor {
            return .white
        }
        
        public var imageEdgeInsets: UIEdgeInsets {
            switch self {
            case .apple:
                return UIEdgeInsets(top: 6, left: 6, bottom: 12, right: 12)
            case .google:
                return UIEdgeInsets(uniform: 8)
            case .instagram:
                return UIEdgeInsets(uniform: 11)
            }
        }
    }
    
    public func createSocialButton(kind: SocialButtonKind) -> UIButton {
        let button = RoundButton(color: .white)
        button.setImage(kind.image, for: .normal)
        button.imageEdgeInsets = kind.imageEdgeInsets
        if let tintColor = kind.tintColor {
            button.tintColor = tintColor
        }
        button.backgroundColor = kind.backgroundColor
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }
}
