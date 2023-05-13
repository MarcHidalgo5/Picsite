//
//  AppDelegate.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func loadWorld() async {
        wireUpTheKits()
    }
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Current = World(environment: {
            #if APPSTORE
                return .production
            #else
                return .development
            #endif
        }())
        SceneDelegate.themeApp()
        UIViewController.enhancedErrorAlertMessage = Current.enhancedErrorLogs
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

import PicsiteMapKit
import PicsiteAuthKit
import PicisteProfileKit

@MainActor
private func wireUpTheKits() {
    //Auth
    PicsiteAuthKit.ModuleDependencies.dataSource = Current.authDataSource
    PicsiteAuthKit.ModuleDependencies.socialManeger = SocialNetworkManager.shared
    
    //Map
    PicsiteMapKit.ModuleDependencies.mapDataSource = Current.mapDataSourceFactory()
    
    //PicsiteProfile
    PicisteProfileKit.ModuleDependencies.dataSource = Current.picsiteProfileDataSourceFactory()
}
