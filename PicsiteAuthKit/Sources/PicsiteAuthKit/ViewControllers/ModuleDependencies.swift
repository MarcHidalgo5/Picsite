//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteKit

public struct ModuleDependencies {

    let authProvider: AuthenticationProviderType
    
    public init(
        authProvider: AuthenticationProviderType
        ) {
            self.authProvider = authProvider
            
        }
}
