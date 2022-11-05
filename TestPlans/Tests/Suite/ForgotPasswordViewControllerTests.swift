//
//  Created by Marc Hidalgo on 5/11/22.
//

import XCTest
import PicsiteKit
@testable import Picsite
@testable import PicsiteAuthKit

class ForgotPasswordViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        let sut = AuthenticationPerformerViewController.ForgotPasswordViewController(provider: MockAuthKit())
        let navVC = MinimalNavigationController(rootViewController: sut)
//        debug(viewController: navVC)
        waitABitAndVerify(viewController: navVC, testDarkMode: true)
    }
}

