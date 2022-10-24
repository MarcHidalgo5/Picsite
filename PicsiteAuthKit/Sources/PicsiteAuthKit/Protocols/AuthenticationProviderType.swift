 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseAuth

public enum AuthenticationKind: String, Codable {
    case register
    case login
    case google
    
    public var isSocial: Bool {
        switch self {
        case .google:
            return true
        case .register, .login:
            return false
        }
    }
}

public protocol AuthenticationProviderType {
    
    var isUserLoggedIn: Bool { get }
    var userID: String? { get }
    var authenticationKind: AuthenticationKind? { get }
    
    func loginUserByEmail(email: String, password: String) async throws -> User
    func loginUsingGoogle(from vc: UIViewController) async throws -> User
    func recoverPasword(email: String) async throws
    
}

public enum AuthenticationManagerError: Swift.Error, Equatable {
    case invalidUsernameOrPassword
    case userCanceled
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .invalidUsernameOrPassword:
            return "authentication-maneger-error-invalid-user-or-pasword".localized
        case .userCanceled:
            return ""
        case .unknownError:
            return "authentication-maneger-error-unknownError".localized
        }
    }
}

public enum AuthenticationValidator {
    
    public static func validateEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: string)
    }

    public static func validatePassword(_ string: String) -> Bool {
        return string.count >= 8
    }

    public static func validateName(_ string: String) -> Bool {
        return string.count > 3
    }
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
