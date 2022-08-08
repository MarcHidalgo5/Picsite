//
//  Created by Marc Hidalgo on 9/8/22.
//

import UIKit
import PicsiteUI; import PicsiteKit
import BSWInterfaceKit

extension AuthenticationPerformerViewController {
    
    class ForgotPasswordViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
        
        private let emailTextField = TextField(kind: .email)
        
        private let titleView: UIView = {
            let titleLabel = UILabel.unlimitedLinesLabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Forgot your password?".localized, color: ColorPalette.picsiteTitleColor, forSize: 24)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private let subTitleView: UIView = {
            let titleLabel = UILabel()
            titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Enter the email with which you registered to receive instructions to reset".localized, color: ColorPalette.picsiteTitleColor, forSize: 20)
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        private var buttonContainer = ActionButtonContainerView(actionTitle: "Recover password")
        
        private let provier: AuthenticationProviderType
        
        init(provider: AuthenticationProviderType) {
            self.provier = provider
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = ColorPalette.picsiteBackgroundColor
            
            //First the button container
            view.addAutolayoutSubview(buttonContainer)
            
            //Then the ContentView
            let stackView = UIStackView(arrangedSubviews: [titleView, subTitleView] + [emailTextField])
            stackView.axis = .vertical
            stackView.layoutMargins = [.left: Constants.BigPadding, .bottom: Constants.BigPadding, .right: Constants.BigPadding, .top: 0]
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.spacing = Constants.Padding
            stackView.alignment = .fill
            stackView.setCustomSpacing(Constants.HugePadding, after: subTitleView)
            view.addAutolayoutSubview(stackView)
            
            // Layout the view
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                buttonContainer.bottomAnchor.constraint(equalTo: view.bswKeyboardLayoutGuide.topAnchor),
                ])
        }
        
        override func viewDidLoad() {
             super.viewDidLoad()
            buttonContainer.actionButton.addTarget(self, action:  #selector(onResetPassword), for: .touchUpInside)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            emailTextField.becomeFirstResponder()
        }
        
        var barStyle: TransparentNavigationBar.TintColorStyle {
            .transparent
        }
        
        @objc private func onResetPassword() {
            guard let email = emailTextField.text else {
                return
            }
            print(email)
        }
    }
}
