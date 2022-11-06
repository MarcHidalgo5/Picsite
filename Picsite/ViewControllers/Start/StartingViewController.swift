//
//  Created by Marc Hidalgo on 22/3/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import PicsiteAuthKit

@MainActor
protocol StartingObserver: AnyObject {
    func didFinishAuthentication()
}

class StartingViewController: UIViewController {
    
    public enum Factory {
        static func viewController(observer: StartingObserver) -> UIViewController {
            let vc = BottomContainerViewController(containedViewController: StartingViewController(observer: observer), bottomViewController: BottomButtonViewController())
            return MinimalNavigationController(rootViewController: vc)
        }
    }
    
    enum Constants {
        static let SmallPadding = CGFloat(0)
        static let LogoSpacing: CGFloat = 150
        static let CornerRadius: CGFloat = 12
        static let LayoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    init(observer: StartingObserver) {
        self.observer = observer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoView = LogoView()
    private var buttonContainer: BottomButtonViewController? {
        guard let vc = self.bottomContainerViewController?.bottomController as? BottomButtonViewController else {
            fatalError()
        }
        return vc
    }
    
    weak var observer: StartingObserver!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .picsiteBackgroundColor
        
        let backgroundImage = UIImage(named: "authentication-image-background")
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
            return imageView
        }()
        backgroundImageView.image = backgroundImage
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0.3
        
        view.addAutolayoutSubview(backgroundImageView)
        view.addAutolayoutSubview(blurredEffectView)
        view.addAutolayoutSubview(logoView)
    
        backgroundImageView.pinToSuperview()
        blurredEffectView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.isTallScreen ? 80 : 60),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlainBackButton()
        buttonContainer?.onGetStarted = { [weak self] in
            guard let self = self else { return }
            let authVC =
            AuthenticationPerformerViewController(dependecies: .forPicsiteRegister(observer: self))
            self.show(authVC, sender: nil)
        }
        buttonContainer?.onLogIn = { [weak self] in
        guard let self = self else { return }
            let authVC =
            AuthenticationPerformerViewController(dependecies: .forPicsiteLogin(observer: self))
            self.show(authVC, sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    class LogoView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let logo = UIImageView(image: UIImage(named: "picsite-icon"))
            let subtitle = UILabel()
            subtitle.attributedText = mediumTextStyler.attributedString("start-subtitle".localized, color: .white, forSize: 24)
            
            let stackView = UIStackView(arrangedSubviews: [
                logo,
                subtitle
            ])
            stackView.arrangedSubviews.forEach { $0.tintColor = .white }
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.alignment = .center
            
            addAutolayoutSubview(stackView)
            
            stackView.pinToSuperviewLayoutMargins()

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension StartingViewController: AuthenticationObserver {
    func didAuthenticate(kind: AuthenticationPerformerKind) {
        switch kind {
        case .register:
            #warning("Tutorial vc?")
            observer.didFinishAuthentication()
        case .login, .google:
            observer.didFinishAuthentication()
        }
    }
    
    func didCancelAuthentication() { }
}

extension StartingViewController: TransparentNavigationBarPreferenceProvider {
    public var barStyle: TransparentNavigationBar.TintColorStyle { .transparent }
}
