//
//  Created by Marc Hidalgo on 8/4/22.
//

import XCTest
import SnapshotTesting
import BSWInterfaceKit
@testable import Picsite
import PicsiteUI
import Foundation

extension String: LocalizedError { }
typealias MinimalNavigationController = PicsiteUI.MinimalNavigationController

@MainActor
class BSWSnapshotTest: XCTestCase {
    
    var recordMode = false
    
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        Current = World(environment: {
            return .development
        }())
        NSTimeZone.default = TimeZone.init(abbreviation: "CET")!
        
        if let value = ProcessInfo.processInfo.environment["GENERATE_SNAPSHOTS"], value == "1" {
            recordMode = true
        }
    }
    
    var currentWindow: UIWindow {
        return UIApplication.shared.windows.first!
    }
    
    var rootViewController: UIViewController? {
        get {
            return currentWindow.rootViewController
        }
        
        set(newRootViewController) {
            currentWindow.rootViewController = newRootViewController
            currentWindow.makeKeyAndVisible()
        }
    }
    
    /// Add the view controller on the window and wait infinitly
    func debug(viewController: UIViewController) {
        let waiter = XCTWaiter()
        // Flip what we do on setUp

        rootViewController = viewController
        let exp = expectation(description: "No expectation")
        let _ = waiter.wait(for: [exp], timeout: 1000)
    }
    
    func debug(view: UIView) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.view.addSubview(view)
        debug(viewController: vc)
    }
    
    /// Presents the VC using a fresh rootVC in the host's main window.
    /// - note: This method blocks the calling thread until the presentation is finished.
    func presentViewController(_ viewController: UIViewController) {
        let waiter = XCTWaiter()
        let exp = expectation(description: "Presentation")
        rootViewController = UIViewController()
        rootViewController!.view.backgroundColor = .white // I just think it looks pretier this way
        rootViewController!.present(viewController, animated: true, completion: {
            exp.fulfill()
        })
        let _ = waiter.wait(for: [exp], timeout: 10)
    }
    
    func waitABitAndVerify(viewController: UIViewController, testDarkMode: Bool = true, file: StaticString = #file, testName: String = #function) {
        rootViewController = viewController
        let waiter = XCTWaiter()
        let exp = expectation(description: "verify view")
        let deadlineTime = DispatchTime.now() + .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            let screenSize = UIScreen.main.bounds
            let currentSimulatorSize = "\(Int(screenSize.width))x\(Int(screenSize.height))"
            assertSnapshot(matching: viewController, as: .image(on: UIScreen.main.currentDevice), named: currentSimulatorSize, record: self.recordMode, file: file, testName: testName)
            if testDarkMode {
                viewController.overrideUserInterfaceStyle = .dark
                assertSnapshot(matching: viewController, as: .image(on: UIScreen.main.currentDevice), named: "Dark" + currentSimulatorSize, record: self.recordMode, file: file, testName: testName)
            }
            exp.fulfill()
        }
        let _ = waiter.wait(for: [exp], timeout: 2)
    }
    
    func verify(view: UIView, file: StaticString = #file, testName: String = #function) {
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        if let scrollView = view as? UIScrollView {
            scrollView.frame = CGRect(
                x: scrollView.frame.origin.x,
                y: scrollView.frame.origin.y,
                width: scrollView.contentSize.width,
                height: scrollView.contentSize.height
            )
        }
        
        let currentSimulatorScale = Int(UIScreen.main.scale)
        assertSnapshot(matching: view, as: .image, named: "\(currentSimulatorScale)x", record: self.recordMode, file: file, testName: testName)
    }
}

private extension UIScreen {
    var currentDevice: ViewImageConfig {
        switch self.bounds.size {
        case CGSize(width: 320, height: 568):
            return .iPhoneSe
        case CGSize(width: 375, height: 667):
            return .iPhone8
        case CGSize(width: 414, height: 736):
            return .iPhone8Plus
        case CGSize(width: 375, height: 812):
            return .iPhoneX
        case CGSize(width: 414, height: 896):
            return .iPhoneXsMax
        case CGSize(width: 768, height: 1024):
            return .iPadMini(.portrait)
        default:
            return .iPhoneX
        }
    }
}


import SnapshotTesting
import Foundation
import XCTest

public extension XCTestCase {
    func verify(urlRequest: URLRequest, file: StaticString = #file, testName: String = #function) {
        assertSnapshot(matching: urlRequest, as: .curl, file: file, testName: testName)
    }
}
