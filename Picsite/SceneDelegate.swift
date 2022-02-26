//
//  SceneDelegate.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import BSWInterfaceKit
import PicsiteKit
import Firebase

protocol SceneDelegateAppStateProvider {
    var currentAppState: AppState { get }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
//        let a = PicsiteKit.init(user: "Hidi")
//        print(a.user)
    
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
            return MainViewController()
        case .login:
            return HomeViewController()
        }
    }
    
    //Private
    
    private var rootViewController: ContainerViewController!
    private var currentAppState: AppState {
        if Auth.auth().currentUser != nil {
            return .login
        } else {
            return .unlogged
        }
    }
    
    static func themeApp() {
        
    }
}

