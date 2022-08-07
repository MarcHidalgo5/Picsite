//
//  AuthenticationProvider.swift
//  Picsite
//
//  Created by Marc Hidalgo on 28/2/22.
//

import PicsiteKit
import BSWFoundation
import Foundation
import FirebaseAuth
import GoogleSignIn
import PicsiteAuthKit

class AuthenticationProvider: AuthenticationProviderType {
    
    private let authAPIClient: AuthAPIClient
    private let authStorage = AuthStorage.defaultStorage
    private let apiClient: PicsiteAPIClient
    private let socialManager: AuthenticationManagerSocialManagerType
    
    init(apiClient: PicsiteAPIClient, environment: PicsiteAPI.Environment) {
        self.authAPIClient = AuthAPIClient(authEnvironment: environment)
        self.socialManager = SocialNetworkManager.shared
        self.apiClient = apiClient
    }
    
    var userID: String? {
        get {
            return authStorage.userID
        } set {
            apiClient.userID = newValue
            authStorage.userID = newValue
        }
    }
    
    @CodableUserDefaultsBacked(key: "authentication-kind", defaultValue: nil)
    var authenticationKind: AuthenticationKind?
    
    var isUserLoggedIn: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }
    
    func loginUserByEmail(email: String, password: String) async throws -> User {
        let user = try await self.authAPIClient.login(email: email, password: password)
        self.authenticationKind = .login
        return user
    }
    
    func loginUsingGoogle(from vc: UIViewController) async throws -> User {
        let socialInfo = try await socialManager.fetchSocialNetworkInfo(forSocialType: .google, fromVC: vc)
        let credential = GoogleAuthProvider.credential(withIDToken: socialInfo.idToken, accessToken: socialInfo.accesToken)
        let user = try await authAPIClient.login(with: credential)
        self.authenticationKind = .google
        return user
    }
}
