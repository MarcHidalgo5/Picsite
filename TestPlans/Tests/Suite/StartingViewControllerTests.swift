//
//  StartingCollectionViewTests.swift
//  Tests
//
//  Created by Marc Hidalgo on 8/4/22.
//

import XCTest
import PicsiteKit
@testable import Picsite

class StartingViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        let sut = StartingViewController.Factory.viewController(observer: self)
//        debug(viewController: sut)
        waitABitAndVerify(viewController: sut, testDarkMode: true)
    }
    
}

extension StartingViewControllerTests: StartingObserver {
    func didFinishAuthentication() { }
}
