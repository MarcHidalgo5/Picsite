//
//  ViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import PicsiteKit

class AuthenticationViewController: UIViewController {
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let PhotoHeight: CGFloat = 85
        static let CornerRadius: CGFloat = 12
    }
    
    private var smallFontSize: CGFloat { UIScreen.main.isSmallScreen ? 16 : 18 }
    private let provider: AuthenticationProviderType
    
    init(authenticationProvider: AuthenticationProviderType) {
        self.provider = authenticationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .picsiteBackgroundColor
        
        let picsiteImage =  UIImage(named: "picsite-icon")!.scaleTo(CGSize(width: 28, height: 28)).withRenderingMode(.alwaysOriginal)
        let backgroundImage = UIImage(named: "authentication-image-background")
        
        let picsiteImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.roundCorners(radius: Constants.CornerRadius)
            imageView.backgroundColor = .clear
            return imageView
        }()
        
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
            return imageView
        }()
        
        picsiteImageView.image = picsiteImage
        backgroundImageView.image = backgroundImage
        
        let appleImage = UIImage(named: "apple-icon")!.scaleTo(CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate)
        let loginAppleButton = UIButton(buttonConfiguration: .init(buttonTitle: .textAndImage(FontPalette.mediumTextStyler.attributedString("Login with Apple", color: .white, forSize: smallFontSize), appleImage), tintColor: .white, backgroundColor: .black, contentInset: UIEdgeInsets(uniform: 10), cornerRadius: Constants.CornerRadius) {
           print("apple login")
        })
       
        
        let googleImage =  UIImage(named: "google-icon")!.scaleTo(CGSize(width: 28, height: 28)).withRenderingMode(.alwaysOriginal)
        let loginGoogleButton = UIButton(buttonConfiguration: .init(buttonTitle: .textAndImage(FontPalette.mediumTextStyler.attributedString("Login with Google", color: .white, forSize: smallFontSize), googleImage), tintColor: .clear, backgroundColor: .black, contentInset: UIEdgeInsets(uniform: 10), cornerRadius: Constants.CornerRadius) {
           print("google login")
        })
        
        let loginEmailButton = UIButton(buttonConfiguration: .init(buttonTitle: .text(FontPalette.mediumTextStyler.attributedString("Login with email", color: .white, forSize: smallFontSize)), tintColor: .clear, backgroundColor: .black, contentInset: UIEdgeInsets(uniform: 10), cornerRadius: Constants.CornerRadius) {
           print("email login")
        })
        
        let signInView = SignInView(onLogin: {
            let vc = LoginViewController(provider: self.provider)
            let navVC = UINavigationController.init(rootViewController: vc)
            self.show(navVC, sender: nil)
        })
        
        let contentStackView = UIStackView(arrangedSubviews: [
            picsiteImageView,
           loginEmailButton,
           loginAppleButton,
           loginGoogleButton,
           signInView,
        ])
        
        contentStackView.axis = .vertical
        contentStackView.layoutMargins = .init(top: 10, left: 40, bottom: 10, right: 40)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.spacing = 10
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
        contentStackView.setCustomSpacing(35, after: loginGoogleButton)
        
        view.addAutolayoutSubview(backgroundImageView)
        view.addAutolayoutSubview(contentStackView)
        backgroundImageView.pinToSuperview()
        contentStackView.pinToSuperviewLayoutMargins()
        NSLayoutConstraint.activate([
            picsiteImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.isTallScreen ? 50 : 30),
            picsiteImageView.heightAnchor.constraint(equalToConstant: Constants.PhotoHeight),
            loginAppleButton.heightAnchor.constraint(equalToConstant: 60),
            loginEmailButton.heightAnchor.constraint(equalToConstant: 60),
            loginGoogleButton.heightAnchor.constraint(equalToConstant: 60),
            signInView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    //Private
    
    private class SignInView: UIView {
        
        private let onLogin: () -> Void
        
        init(onLogin: @escaping () -> Void) {
            self.onLogin = onLogin
            super.init(frame: .zero)
            let loginButton = UIButton(type: .system)
            loginButton.prepareForMultiline(maxWidth: 300, horizontalAlignment: .center)
            loginButton.tintColor = .picsiteTintColor
            addAutolayoutSubview(loginButton)
            NSLayoutConstraint.activate([
                loginButton.topAnchor.constraint(equalTo: topAnchor),
                loginButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
            loginButton.addTarget(self, action: #selector(_onLogin), for: .touchUpInside)
            let firstPartOfMessage =
            FontPalette.mediumTextStyler.attributedString("You don't have an account yet?", color: .black, forSize: 17)
            let secondPartOfMessage = FontPalette.boldTextStyler.attributedString("Sign in", color: .black, forSize: 17)
            let finalMessage = [firstPartOfMessage, secondPartOfMessage]
                .joinedStrings()
                .settingParagraphStyle {
                    $0.lineHeightMultiple = 1.3
                    $0.alignment = .center
                }
            loginButton.setAttributedTitle(finalMessage, for: .normal)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func _onLogin() {
            self.onLogin()
        }
    }
}

