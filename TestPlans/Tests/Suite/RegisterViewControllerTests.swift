//
//  Created by Marc Hidalgo on 5/11/22.
//

import XCTest
import PicsiteKit
@testable import Picsite
@testable import PicsiteAuthKit

class RegisterViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        let sut = AuthenticationPerformerViewController(dependecies: .forPicsiteRegister(observer: self))
        let navVC = MinimalNavigationController(rootViewController: sut)
//        debug(viewController: navVC)
        waitABitAndVerify(viewController: navVC, testDarkMode: true)
    }
}

extension RegisterViewControllerTests: AuthenticationObserver {
    func didAuthenticate(kind: AuthenticationPerformerKind) { }
    func didCancelAuthentication() { }
}

func forPicsiteRegister(observer: AuthenticationObserver) -> ModuleDependencies {
    return ModuleDependencies(authProvider: MockAuthKit(), socialManager: SocialNetworkManager.shared, mode: .register, observer: observer)
}

