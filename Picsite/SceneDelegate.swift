//
//  SceneDelegate.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import SwiftUI
import BSWInterfaceKit

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
        
//        let rootWindowController = ContainerViewController(containedViewController: <#T##UIViewController#>)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
//        updateRootViewController(forAppState: App.appStateProvider.currentAppState)
    }

//    private func createCurrentViewController() -> UIViewController {
//        guard !UIApplication.shared.isRunningTests else {
//            return UIViewController()
//        }
//        switch currentAppState {
//        case .walkthrough:
//            return WalkthroughViewController.Factory.viewController(observer: self)
//        case .teamSelection:
//            let selectTeamHandler: VoidHandler = { [weak self] in
//                self?.updateContainedViewController()
//            }
//            if let deeplink = queuedDeeplink, case .teamInvitation(let token, _) = deeplink.kind {
//                self.queuedDeeplink = nil
//                return TeamAcceptInvitationsViewController(invitationID: token, teamID: deeplink.teamID, didSelectTeam: selectTeamHandler)
//            } else {
//                return TeamSelectionViewController.Factory.stateViewController(didSelectTeam: selectTeamHandler)
//            }
//        case .renewingToken:
//            return RenewTokenViewController()
//        case .normal:
//            defer {
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.sceneWillTransitionToNormalState()
//            }
//            if let deeplink = queuedDeeplink {
//                self.queuedDeeplink = nil
//                /// When handling `userActivities` after the app launches, let's add
//                 /// 300 miliseconds delay so the UI hierarchy is rendered correctly
//                 DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
//                     self.handleDeeplink(deeplink: deeplink)
//                 }
//             }
//            return VideoAsk.SplitViewController()
//        }
//    }
    
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
    
//    private var currentAppState: AppState {
//
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

