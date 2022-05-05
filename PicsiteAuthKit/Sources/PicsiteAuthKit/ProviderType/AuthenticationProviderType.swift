//
//  AuthenticationProviderType.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseAuth

public protocol AuthenticationProviderType {
    
    var isUserLoggedIn: Bool { get }
    
    func loginUser(email: String, password: String) async throws -> User
    func loginUsingGoogle(with socialInfo: AuthenticationManagerSocialInfo) async throws
    
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
