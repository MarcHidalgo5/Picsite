//
//  PicsiteAuthenticationKit.swift
//  Picsite
//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteAuthKit

extension PicsiteAuthKit.ModuleDependencies {
    
    static func forPicsiteLogin(observer: AuthenticationObserver) -> ModuleDependencies {
        return ModuleDependencies(dataSource: Current.authDataSource, socialManager: SocialNetworkManager.shared, mode: .login, observer: observer)
    }
    
    static func forPicsiteRegister(observer: AuthenticationObserver) -> ModuleDependencies {
        return ModuleDependencies(dataSource: Current.authDataSource, socialManager: SocialNetworkManager.shared, mode: .register, observer: observer)
    }
}
