//
//  SceneDelegate.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import BSWInterfaceKit
import PicsiteKit
import PicsiteUI

protocol SceneDelegateAppStateProvider {
    var currentAppState: AppState { get }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    static var main: SceneDelegate? {
        return UIApplication.shared.connectedScenes.compactMap { $0.delegate as? SceneDelegate }.first
    }

    func updateContainedViewController(animated: Bool = true) {
        /// Make sure nothing is on top of the rootVC before updating it
        rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
        rootViewController.updateContainedViewController(createCurrentViewController(forAppState: currentAppState), animated: animated)
    }
    
    //MARK: UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootViewController = ContainerViewController(containedViewController: createCurrentViewController(forAppState: .loading))
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        self.rootViewController = rootViewController
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

    private func createCurrentViewController(forAppState appState: AppState) -> UIViewController {
        guard !UIApplication.shared.isRunningTests else {
            return UIViewController()
        }
        switch appState {
        case .start:
            return StartingViewController.Factory.viewController(observer: self)
        case .normal:
            return TabBarController()
        case .loading:
            return LoadingAppStateViewController()
        }
    }
    
    //Private
    
    private var rootViewController: ContainerViewController!
    private var currentAppState: AppState {
        if Current.authDataSource.isUserLoggedIn {
            return .normal
        } else {
            return .start
        }
    }
    
    static func themeApp() {
        ///Customize UIKit
        UIWindow.appearance().tintColor = .picsiteBlackTintColor
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .picsiteBlackTintColor
        UITabBar.appearance().tintColor = .picsiteDeepBlueColor
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: mediumTextStyler.fontForSize(11)],
          for: .normal)
        UITextField.appearance().tintColor = .picsiteBlackTintColor
        UITextField.appearance().font = regularTextStyler.fontForSize(18)
        
        [UIControl.State.normal, UIControl.State.highlighted].forEach {
             UIBarButtonItem.appearance(whenContainedInInstancesOf: [TransparentNavigationBar.self]).setTitleTextAttributes([
                 .font: mediumTextStyler.fontForSize(16)
                 ], for: $0)
         }
        
        UISwitch.appearance().onTintColor = .picsiteDeepBlueColor
        
        UIViewController.loadingViewFactory = { UIView.picsiteLoadingView() }
        
        /// Hook up VideoAskUI with dependencies
        PicsiteUI.ColorPalette.picsiteTintColor = UIColor.picsiteBlackTintColor
        PicsiteUI.ColorPalette.picsiteTitleColor = UIColor.picsiteTitleColor
        PicsiteUI.ColorPalette.picsiteSecondaryTitleColor = UIColor.picsiteSecondaryTitleColor
        PicsiteUI.ColorPalette.picsiteSecondaryBackgroundColor = UIColor.picsiteSecondaryBackgroundColor
        PicsiteUI.ColorPalette.picsiteBackgroundColor = UIColor.picsiteBackgroundColor
        PicsiteUI.ColorPalette.picsiteDeepBlueColor =
            UIColor.picsiteDeepBlueColor
        PicsiteUI.ColorPalette.picsiteButtonTitleColor = UIColor.picsiteButtonTitleColor
        PicsiteUI.ColorPalette.picsitePlaceholderColor = UIColor.picsitePlaceholderColor
        PicsiteUI.ColorPalette.picsiteErrorColor = UIColor.picsiteErrorColor
        
        PicsiteUI.FontPalette.boldTextStyler = boldTextStyler
        PicsiteUI.FontPalette.mediumTextStyler = mediumTextStyler
        PicsiteUI.FontPalette.regularTextStyler = regularTextStyler
        
    }
}

extension SceneDelegate: StartingObserver {
    func didFinishAuthentication() {
        updateContainedViewController()
    }
}

private class LoadingAppStateViewController: SplashViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { @MainActor in
            await AppDelegate.shared.loadWorld()
            SceneDelegate.main?.updateContainedViewController(animated: false)
        }
    }
}
