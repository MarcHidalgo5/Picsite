 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseAuth

public enum AuthenticationKind: String, Codable {
    case register
    case login
    case apple
    case google
    case instagram
    
    public var isSocial: Bool {
        switch self {
        case .apple, .google, .instagram:
            return true
        case .register, .login:
            return false
        }
    }
}

public protocol AuthenticationProviderType {
    
    var isUserLoggedIn: Bool { get }
    
    func loginUserByEmail(email: String, password: String) async throws -> User
    func loginUsingGoogle(from vc: UIViewController) async throws -> User
}

public enum AuthenticationManagerSocial {
    case apple
    case google
}

public typealias AuthenticationManagerSocialInfo = (idToken: String, accesToken: String)

#if canImport(UIKit)

import UIKit

public protocol AuthenticationManagerSocialManagerType {
    func fetchSocialNetworkInfo(forSocialType social: AuthenticationManagerSocial, fromVC: UIViewController) async throws -> AuthenticationManagerSocialInfo
}

#endif
