//
//  PicsiteAuthenticationKit.swift
//  Picsite
//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteAuthKit

extension PicsiteAuthKit.ModuleDependencies {
    
    static func forPicsite() -> ModuleDependencies {
        return ModuleDependencies(authProvider: Current.authProviderFactory())
    }
}
