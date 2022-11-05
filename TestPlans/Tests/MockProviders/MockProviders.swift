//
//  Created by Marc Hidalgo on 3/11/22.
//

import Foundation
import UIKit
import BSWInterfaceKit
import PicsiteKit
@testable import Picsite
@testable import PicsiteAuthKit

class MockAuthKit: AuthenticationProviderType {
    var isUserLoggedIn: Bool = false
    var authenticationKind: AuthenticationType? = .email
    
    func loginUserByEmail(email: String, password: String) async throws { try await Task.never }
    func loginUsingGoogle(from vc: UIViewController) async throws { try await Task.never }
    func registerUser(username: String, fullName: String, email: String, password: String) async throws { try await Task.never }
    func recoverPasword(email: String) async throws { try await Task.never }
    func isUsernameCurrentUsed(username: String) async throws -> Bool { try await Task.never() }
}
