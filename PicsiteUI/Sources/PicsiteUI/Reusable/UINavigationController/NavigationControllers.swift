//
//  Created by Marc Hidalgo on 6/4/22.
//

import UIKit

public protocol TransparentNavigationBarPreferenceProvider: UIViewController {
    var barStyle: TransparentNavigationBar.TintColorStyle { get }
    var prefersLargeTitles: Bool { get }
}

public extension TransparentNavigationBarPreferenceProvider {
    var prefersLargeTitles: Bool { false }
}

open class MinimalNavigationController: UINavigationController {
    
    override public init(rootViewController: UIViewController) {
        super.init(navigationBarClass: TransparentNavigationBar.self, toolbarClass: nil)
        self.viewControllers = [rootViewController]
        updateNavBarStyle(forViewController: rootViewController)
        if let preferencesProvider = rootViewController as? TransparentNavigationBarPreferenceProvider {
            navigationBar.prefersLargeTitles = preferencesProvider.prefersLargeTitles
        }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setValue(TransparentNavigationBar(), forKey: "navigationBar")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setValue(TransparentNavigationBar(), forKey: "navigationBar")
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateNavBarStyle(forViewController: viewController)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if let visibleVC = viewControllers.last {
            updateNavBarStyle(forViewController: visibleVC)
        }
        setNeedsStatusBarAppearanceUpdate()
        return vc
    }
    
    private func updateNavBarStyle(forViewController vc: UIViewController) {
        guard let navBar = navigationBar as? TransparentNavigationBar else {
            return
        }
        
        /// Find the correct childVC to ask the status bar style
        let correctVC: UIViewController = {
            var childVC = vc
            while let otherChild = childVC.childForStatusBarStyle {
                childVC = otherChild
            }
            return childVC
        }()
        
        if let preferencesProvider = correctVC as? TransparentNavigationBarPreferenceProvider {
            navBar.tintColorStyle = preferencesProvider.barStyle
        } else {
            /// Try to guess it depending on the status bar Style
            if correctVC.preferredStatusBarStyle == .lightContent {
                navBar.tintColorStyle = .transparent
            } else {
                navBar.tintColorStyle = .solid()
            }
        }
    }
        
    override public var childForStatusBarStyle: UIViewController? {
        viewControllers.last
    }
}

public class TransparentNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColorStyle = .solid()
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let justRefreshThis = tintColorStyle
        tintColorStyle = justRefreshThis
    }
    
    public enum TintColorStyle {
        case transparent
        case solid(TranslucencyPreference = .translucentOnLightContent)
    }
    
    public enum TranslucencyPreference {
        case neverTranslucent
        case alwaysTranslucent
        case translucentOnLightContent
    }
    
    public var tintColorStyle: TintColorStyle! {
        didSet {
            TransparentNavigationBar.applyStyle(tintColorStyle, toNavigationBar: self, traitCollection: traitCollection)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func applyStyle(_ style: TintColorStyle, toNavigationBar navBar: UINavigationBar, traitCollection: UITraitCollection) {
        navBar.shadowImage = UIImage()
        navBar.tintColor = ColorPalette.picsiteTintColor
        let titleTextAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: ColorPalette.picsiteTitleColor!,
            .font: FontPalette.mediumTextStyler.fontForSize(18),
        ]
        switch style {
        case .solid(let translucency):
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = ColorPalette.picsiteBackgroundColor
                appearance.titleTextAttributes = titleTextAttributes
                navBar.standardAppearance = appearance
                navBar.scrollEdgeAppearance = appearance
            } else {
                navBar.barTintColor = ColorPalette.picsiteBackgroundColor
                navBar.setBackgroundImage(nil, for: .default)
                navBar.titleTextAttributes = titleTextAttributes
            }
            switch translucency {
            case .alwaysTranslucent:
                navBar.isTranslucent = true
            case .neverTranslucent:
                navBar.isTranslucent = false
            case .translucentOnLightContent:
                navBar.isTranslucent = (traitCollection.userInterfaceStyle == .light)
            }
        case .transparent:
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                navBar.standardAppearance = appearance
                navBar.scrollEdgeAppearance = appearance
            } else {
                navBar.barTintColor = nil
                navBar.setBackgroundImage(UIImage(), for: .default)
            }
            navBar.isTranslucent = true
        }
    }
}
