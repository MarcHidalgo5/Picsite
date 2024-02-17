//
//  MapViewControllerTests.swift
//  Tests
//
//  Created by Marc Hidalgo on 23/8/23.
//

import Foundation
import PicsiteKit
@testable import Picsite
@testable import PicsiteMapKit

class MapViewControllerTests: BSWSnapshotTest {
    
    func testLayout() {
        ModuleDependencies.dataSource = MockMapDataSource()
        let sut = MapViewController()
        let navVC = MinimalNavigationController(rootViewController: sut)
//                debug(viewController: navVC)
                waitABitAndVerify(viewController: navVC, testDarkMode: true, deadlineTime: 4000)
    }
}
