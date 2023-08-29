//
//  LoginViewControllerTests.swift
//  Tests
//
//  Created by Marc Hidalgo on 3/11/22.
//

import XCTest
import PicsiteKit
@testable import Picsite
@testable import PicsiteAuthKit

class LoginViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        ModuleDependencies.dataSource = MockAuthKit()
        ModuleDependencies.socialManeger = SocialNetworkManager()
        let sut = AuthenticationPerformerViewController(mode: .login, observer: self)
        let navVC = MinimalNavigationController(rootViewController: sut)
//        debug(viewController: navVC)
        waitABitAndVerify(viewController: navVC, testDarkMode: true)
    }
}

extension LoginViewControllerTests: AuthenticationObserver {
    func didAuthenticate(kind: AuthenticationPerformerKind) { }
    func didCancelAuthentication() { }
}
