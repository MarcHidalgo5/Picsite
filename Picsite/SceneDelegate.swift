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

    func updateContainedViewController() {
        /// Make sure nothing is on top of the rootVC before updating it
        rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
        rootViewController.updateContainedViewController(createCurrentViewController())
    }
    
    //MARK: UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootViewController = ContainerViewController(containedViewController: createCurrentViewController())
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

    private func createCurrentViewController() -> UIViewController {
        guard !UIApplication.shared.isRunningTests else {
            return UIViewController()
        }
        switch currentAppState {
        case .unlogged:
            return StartingViewController.Factory.viewController(observer: self)
        case .login:
            return TabBarController()
        }
    }
    
    //Private
    
    private var rootViewController: ContainerViewController!
    private var currentAppState: AppState {
        if Current.authProvider.isUserLoggedIn {
            return .login
        } else {
            return .unlogged
        }
    }
    
    static func themeApp() {
        ///Customize UIKit
        UIWindow.appearance().tintColor = .picsiteTintColor
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .picsiteTintColor
        
        /// Hook up VideoAskUI with dependencies
        PicsiteUI.ColorPalette.picsiteTintColor = UIColor.picsiteTintColor
        PicsiteUI.ColorPalette.picsiteTitleColor = UIColor.picsiteTitleColor
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
