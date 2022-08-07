//
//  File.swift
//  
//
//  Created by Marc Hidalgo on 5/5/22.
//

import UIKit
import PicsiteUI
import PicsiteKit
import BSWInterfaceKit

public class AuthenticationPerformerViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    public enum Factory {
        static func viewController(dependecies: ModuleDependencies, observer: AuthenticationObserver) -> UIViewController {
            let vc = AuthenticationPerformerViewController(dependecies: dependecies)
            return vc
        }
    }
    
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
            return UIScreen.main.isSmallScreen ? 25 : 30
        }()
    }

    private let buttonContainer: ActionButtonContainerView
    private let scrollView = UIScrollView()
    private var contentVC: AuthenticationPerformerContentViewController!
    public let dependencies: ModuleDependencies
    
    public init(dependecies: ModuleDependencies) {
        self.dependencies = dependecies
        self.buttonContainer = ActionButtonContainerView(actionTitle: dependencies.mode.actionTitle)
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
            switch dependencies.mode {
            case .login:
                return LoginViewController(provider: self.dependencies.authProvider, observer: dependencies.observer)
            case .register:
                fatalError()
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
            contentVC.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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
            forSize: 14
        )
    }
    
    //MARK: IBActions
    
    @objc private func onPerformAuthentication() {
        do {
            self.view.endEditing(true)
            try contentVC.validateFields()
            contentVC.disableAllErrorFields()
            self.showIndeterminateLoadingView(message: "indeterminate-message-log-in".localized)
            Task { @MainActor in
                do {
                    let userID = try await contentVC.performAuthentication()
                    self.dependencies.observer.didAuthenticate(userID: userID, kind: self.dependencies.mode == .login ? .login : .register)
                } catch {
                    self.showErrorAlert(error.localizedDescription, error: error)
                }
                hideIndeterminateLoadingView()
            }
        } catch let errors as ValidationErrors {
            contentVC.performValidationAnimations(contentVC.animationsFor(errors: errors))
        } catch let error {
            self.showErrorAlert("Unknown Error", error: error)
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
    
//    enum ValidationErrors: Swift.Error {
//        case invalidEmail
//        case invalidPassword
//        case invalidName
//        case didNotAcceptTC
//    }
    
    struct ValidationErrors: OptionSet, Swift.Error {
        let rawValue: Int
        
        static let invalidEmail         = ValidationErrors(rawValue: 1 << 0)
        static let invalidPassword      = ValidationErrors(rawValue: 1 << 1)
        static let invalidName          = ValidationErrors(rawValue: 1 << 2)
        static let didNotAcceptTC       = ValidationErrors(rawValue: 1 << 3)
        static let didNotAcceptPrivacy  = ValidationErrors(rawValue: 1 << 4)
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
