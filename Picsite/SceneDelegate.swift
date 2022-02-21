//
//  SceneDelegate.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import SwiftUI
import BSWInterfaceKit
import PicsiteKit

protocol SceneDelegateAppStateProvider {
    var currentAppState: AppState { get }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static var main: SceneDelegate? {
        return UIApplication.shared.connectedScenes.compactMap { $0.delegate as? SceneDelegate }.first
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let a = PicsiteKit.init(user: "Hidi")
        print(a.user)
//        let rootWindowController = ContainerViewController(containedViewController: <#T##UIViewController#>)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
//        updateRootViewController(forAppState: App.appStateProvider.currentAppState)
    }

    private func createCurrentViewController() -> UIViewController {
        guard !UIApplication.shared.isRunningTests else {
            return UIViewController()
        }
        
        switch currentAppState {
            
        case .unlogged:
            return UIViewController()
        case .login:
            return UIViewController()
        }
    }
    
    func updateRootViewController(forAppState appState: AppState) {
        
        let newViewController: UIViewController = {
            guard !UIApplication.shared.isRunningTests else {
                return UIViewController()
            }
            switch appState {
            case .unlogged:
                return MainViewController()
            case .login:
                fatalError()
            }
        }()
        
        if let rootViewController = self.rootViewController {
            rootViewController.updateContainedViewController(newViewController)
        } else {
            window?.rootViewController = ContainerViewController(containedViewController: newViewController)
        }
    }
    
    //Private
    
    private var rootViewController: ContainerViewController? {
        return self.window?.rootViewController as? ContainerViewController
    }

    private var currentAppState: AppState {
        return .unlogged
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

