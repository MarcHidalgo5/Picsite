//
//  PicsiteAuthenticationKit.swift
//  Picsite
//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteAuthKit

extension PicsiteAuthKit.ModuleDependencies {
    
    static func forPicsiteLogin(observer: AuthenticationObserver) -> ModuleDependencies {
        return ModuleDependencies(authProvider: Current.authProvider, socialManager: SocialNetworkManager.shared, mode: .login, observer: observer)
    }
}
