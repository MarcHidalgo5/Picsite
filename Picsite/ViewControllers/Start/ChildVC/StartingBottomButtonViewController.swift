//
//  Created by Marc Hidalgo on 6/4/22.
//

import BSWInterfaceKit
import BSWFoundation
import UIKit; import Foundation
import PicsiteUI

extension StartingViewController {
    
    @objc(StartingBottomButtonViewController)
    class BottomButtonViewController: UIViewController {
        
        static let CornerRadius: CGFloat = 12
        
        var onGetStarted: VoidHandler?
        
        var onLogIn: VoidHandler?
        
        override func loadView() {
            let fontSize: CGFloat = UIScreen.main.isSmallScreen ? 18 : 22
            
            let getStartedButton: UIButton = {
                var config = UIButton.Configuration.filled()
                config.title = "start-button".localized
                config.setFont(fontDescriptor: mediumTextStyler.fontDescriptor!, size: fontSize, foregroundColor: .white)
                config.baseForegroundColor = .white
                config.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                config.cornerStyle = .medium
                config.contentInsets = .init(uniform: 20)
                return .init(configuration: config, primaryAction: UIAction(handler: { [weak self] action in
                    self?.onGetStarted?()
                }))
            }()
            
            let signUpView = SignUpView(onLogin: { [weak self] in
                self?.onLogIn?()
            })
            
            getStartedButton.layer.shadowColor = UIColor.black.cgColor
            getStartedButton.layer.shadowOpacity = 0.4
            getStartedButton.layer.shadowRadius = 4
            getStartedButton.layer.shadowOffset = .zero
            
            let stackView = UIStackView(arrangedSubviews: [getStartedButton, signUpView])
            stackView.spacing = Constants.SmallPadding
            stackView.layoutMargins = Constants.LayoutMargins 
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.axis = .vertical
            
            NSLayoutConstraint.activate([
                getStartedButton.heightAnchor.constraint(equalToConstant: 56)
            ])
            
            view = UIView()
            view.addAutolayoutSubview(stackView)
            
            stackView.pinToSuperviewLayoutMargins()
        }
    }

    private class SignUpView: UIView {
        
        private let onLogin: () -> Void
        
        init(onLogin: @escaping () -> Void) {
            self.onLogin = onLogin
            super.init(frame: .zero)
            let loginButton = UIButton(type: .system)
            loginButton.prepareForMultiline(maxWidth: 300, horizontalAlignment: .center)
            addAutolayoutSubview(loginButton)
            NSLayoutConstraint.activate([
                loginButton.topAnchor.constraint(equalTo: topAnchor),
                loginButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
            loginButton.addTarget(self, action: #selector(_onLogin), for: .touchUpInside)
            let firstPartOfMessage =
            regularTextStyler.attributedString("start-login-title".localized, color: .white, forSize: 16)
            let secondPartOfMessage = boldTextStyler.attributedString("start-login-subtitle".localized, color: .white, forSize: 16)
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
