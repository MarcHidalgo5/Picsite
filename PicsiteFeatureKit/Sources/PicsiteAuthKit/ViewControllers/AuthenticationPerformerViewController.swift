 //
//  Created by Marc Hidalgo on 5/5/22.
//

import UIKit
import PicsiteUI; import PicsiteKit
import BSWInterfaceKit

public class AuthenticationPerformerViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    public enum Mode {
        case login
        case register
    }
    
    enum Constants {
        static let SmallPadding = Padding/2
        static let Padding = CGFloat(14)
        static let BigPadding: CGFloat = {
            return UIScreen.main.isSmallScreen ? 18 : 20
        }()
        static let HugePadding: CGFloat = {
            return UIScreen.main.isSmallScreen ? 15 : 20
        }()
    }

    private let buttonContainer: ActionButtonContainerView
    private let scrollView = UIScrollView()
    private var contentVC: AuthenticationPerformerContentViewController!
    private let mode: AuthenticationPerformerViewController.Mode
    private let dataSource = ModuleDependencies.dataSource!
    private let observer: AuthenticationObserver!
    
    public init(mode: AuthenticationPerformerViewController.Mode, observer: AuthenticationObserver) {
        self.mode = mode
        self.observer = observer
        self.buttonContainer = ActionButtonContainerView(actionTitle: mode.actionTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = UIView()
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        buttonContainer.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        view.addAutolayoutSubview(scrollView)
        scrollView.pinToSuperview()
        
        contentVC = {
            switch mode {
            case .login:
                return LoginViewController(dataSource: self.dataSource, observer: self.observer)
            case .register:
                return RegisterViewController(dataSource: self.dataSource, observer: self.observer)
            }
        }()
        
        addChild(contentVC)
        scrollView.addAutolayoutSubview(contentVC.view)
        contentVC.didMove(toParent: self)
        
        view.addAutolayoutSubview(buttonContainer)
        
        NSLayoutConstraint.activate([
            contentVC.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentVC.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentVC.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60),
            contentVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: view.bswKeyboardLayoutGuide.topAnchor),
        ])
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        assert(navigationController != nil)
        addPlainBackButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        buttonContainer.actionButton.addTarget(self, action: #selector(onPerformAuthentication), for: .touchUpInside)
    }
    
    static func attributeErrorString(_ string: String) -> NSAttributedString {
        return FontPalette.mediumTextStyler.attributedString(
            string,
            color: ColorPalette.picsiteErrorColor,
            forSize: 12
        )
    }
    
    //MARK: IBActions
    
    @objc private func onPerformAuthentication() {
        self.view.endEditing(true)
        Task { @MainActor in
            do {
                let message = self.mode == .login ? "login-indeterminate-message".localized : "register-indeterminate-message".localized
                self.showIndeterminateLoadingView(message: message)
                try contentVC.validateFields()
                contentVC.disableAllErrorFields()
                try await contentVC.performAuthentication()
                self.observer.didAuthenticate(kind: self.mode == .login ? .login : .register)
            } catch let errors as ValidationErrors  {
                contentVC.performValidationAnimations(contentVC.animationsFor(errors: errors))
            } catch let error as AuthenticationPerformerError {
                   self.showAlert(error.errorDescription)
            } catch let error {
                self.showErrorAlert(error.localizedDescription, error: error)
            }
            hideIndeterminateLoadingView()
        }
    }
    
    private func processError(_ error: Error) { }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + buttonContainer.frame.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
}

extension AuthenticationPerformerViewController {
    
    struct ValidationErrorAnimation {
        let field: AuthenticationField
        let message: String?
    }
    
    struct ValidationErrors: OptionSet, Swift.Error {
        let rawValue: Int
        
        static let invalidEmail          = ValidationErrors(rawValue: 1 << 0)
        static let invalidPassword       = ValidationErrors(rawValue: 1 << 1)
        static let invalidUsername       = ValidationErrors(rawValue: 1 << 2)
        static let invalidName           = ValidationErrors(rawValue: 1 << 3)
        static let didNotAcceptTC        = ValidationErrors(rawValue: 1 << 4)
        static let didNotAcceptPrivacy   = ValidationErrors(rawValue: 1 << 5)
    }
}

private extension AuthenticationPerformerViewController.Mode {
    var actionTitle: String {
        switch self {
        case .login:
            return "authentication-performer-login-button".localized
        case .register:
            return "authentication-performer-signup-button".localized
        }
    }
}

extension AuthenticationPerformerViewController {

    public class SocialSeparatorView: UIView {
        public init() {
            super.init(frame: .zero)
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.opaqueSeparator
            addAutolayoutSubview(separatorView)
            NSLayoutConstraint.activate([
                separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 1),
                separatorView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

