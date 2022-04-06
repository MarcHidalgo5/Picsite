//
//  Created by Marc Hidalgo on 22/3/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI

@MainActor
protocol StartingObserver: AnyObject {
    func didFinishStart()
}


class StartingViewController: UIViewController {
    
    enum Factory {
        static func viewController(observer: StartingObserver) -> UIViewController {
            let vc = BottomContainerViewController(containedViewController: StartingViewController(observer: observer), bottomViewController: BottomButtonViewController())
            return MinimalNavigationController(rootViewController: vc)
        }
    }
    
    enum Constants {
        static let SmallPadding = CGFloat(8)
        static let LogoSpacing: CGFloat = 150
        static let CornerRadius: CGFloat = 122
        static let LayoutMargins = UIEdgeInsets(top: 32, left: 80, bottom: 32, right: 80)
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
        
        view.addAutolayoutSubview(backgroundImageView)
        view.addAutolayoutSubview(logoView)
        
        backgroundImageView.pinToSuperview()
        
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
            let authVC = AuthenticationViewController(authenticationProvider: Current.authProvider, observer: self)
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
    func didFinishAuthentication() {
        
    }
}

extension StartingViewController: TransparentNavigationBarPreferenceProvider {
    public var barStyle: TransparentNavigationBar.TintColorStyle { .transparent }
}
