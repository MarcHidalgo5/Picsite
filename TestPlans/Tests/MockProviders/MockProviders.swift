//
//  Created by Marc Hidalgo on 3/11/22.
//

import Foundation
import UIKit
import BSWInterfaceKit
import PicsiteKit; import PicsiteUI
@testable import Picsite
@testable import PicsiteAuthKit
@testable import PicsiteMapKit

class MockAuthKit: AuthenticationDataSourceType {
    var isUserLoggedIn: Bool = false
    var authenticationKind: AuthenticationType? = .email
    
    func loginUserByEmail(email: String, password: String) async throws { try await Task.never }
    func loginUsingGoogle(from vc: UIViewController) async throws { try await Task.never }
    func registerUser(username: String, fullName: String, email: String, password: String) async throws { try await Task.never }
    func recoverPasword(email: String) async throws { try await Task.never }
    func isUsernameCurrentUsed(username: String) async throws -> Bool { try await Task.never() }
}

class MockMapDataSource: MapDataSourceType {
    func fetchAnnotations() async throws -> BaseMapViewController.VM {
        return .init(
            annotations: [
                .init(
                    coordinate: .init(latitude: 41.60827, longitude: 0.62359),
                    activity: .lastMonthUsed,
                    picsiteData: .init(title: "Test", coordinate: .init(latitude: 41.60827, longitude: 0.62359), location: "Lleida"),
                    thumbnailPhoto: .emptyPhoto(),
                    lastActivityDateString: "03/08/1995"
                )
            ]
        )
    }
    
    func picsiteProfileViewController(picsiteID: String) -> UIViewController {
        return UIViewController()
    }
}
