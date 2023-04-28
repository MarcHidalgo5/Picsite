//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseAuth

public protocol AuthenticationDataSourceType {
    
    var isUserLoggedIn: Bool { get }
    var authenticationKind: AuthenticationType? { get }
    
    func loginUserByEmail(email: String, password: String) async throws
    func loginUsingGoogle(from vc: UIViewController) async throws
    func registerUser(username: String, fullName: String, email: String, password: String) async throws
    func recoverPasword(email: String) async throws
}

#if canImport(UIKit)

import UIKit

public protocol AuthenticationManagerSocialManagerType {
    func fetchSocialNetworkInfo(forSocialType social: AuthenticationManagerSocial, fromVC: UIViewController) async throws -> AuthenticationManagerSocialInfo
}

#endif


public enum AuthenticationPerformerKind: String, Codable {
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

public enum AuthenticationType: String, Codable {
    case email
    case google
    
    public var isSocial: Bool {
        switch self {
        case .google:
            return true
        case .email:
            return false
        }
    }
}


public enum AuthenticationPerformerError: Swift.Error {
    case usenameUnavaliable
    
    public var errorDescription: String {
        switch self {
        case .usenameUnavaliable:
            return "Username already exists"
        }
    }
}

public enum AuthenticationManagerError: Swift.Error, Equatable {
    case userCanceled

    public var errorDescription: String? {
        switch self {
        case .userCanceled:
            return ""
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
        let emailRegEx = "[A-Za-z ]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: string) && string.count > 3
    }
    
    public static func validatUsername(_ string: String) -> Bool {
        return string.count >= 6
    }
}

public enum AuthenticationManagerSocial {
    case apple
    case google
}

public typealias AuthenticationManagerSocialInfo = (idToken: String, accesToken: String)


