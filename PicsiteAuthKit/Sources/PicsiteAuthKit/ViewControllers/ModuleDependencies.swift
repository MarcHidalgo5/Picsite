//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteKit

public struct ModuleDependencies {

    let authProvider: AuthenticationProviderType
    let socialManager: AuthenticationManagerSocialManagerType
    
    public init(
        authProvider: AuthenticationProviderType,
        socialManager: AuthenticationManagerSocialManagerType
        ) {
            self.authProvider = authProvider
            self.socialManager = socialManager
        }
}
