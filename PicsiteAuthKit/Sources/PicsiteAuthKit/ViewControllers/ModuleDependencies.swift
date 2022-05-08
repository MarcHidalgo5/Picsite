//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteKit
import SwiftUI

public struct ModuleDependencies {

    let authProvider: AuthenticationProviderType
    let socialManager: AuthenticationManagerSocialManagerType
    let mode: AuthenticationPerformerViewController.Mode
    let observer: AuthenticationObserver
    
    public init(
        authProvider: AuthenticationProviderType,
        socialManager: AuthenticationManagerSocialManagerType,
        mode: AuthenticationPerformerViewController.Mode,
        observer: AuthenticationObserver
        ) {
            self.authProvider = authProvider
            self.socialManager = socialManager
            self.mode = mode
            self.observer = observer
        }
}
