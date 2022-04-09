//
//  AuthenticationViewControllerTests.swift
//  Tests
//
//  Created by Marc Hidalgo on 9/4/22.
//

import XCTest
import PicsiteKit
@testable import Picsite

class AuthenticationViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        let sut = AuthenticationViewController(authenticationProvider: Current.authProvider, observer: self)
//        debug(viewController: sut)
        waitABitAndVerify(viewController: sut, testDarkMode: true)
    }
    
}

extension AuthenticationViewControllerTests: AuthenticationObserver {
    func didFinishAuthentication() { }

}

