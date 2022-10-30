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
    
    @CodableUserDefaultsBacked(key: "authentication-kind", defaultValue: nil)
    var authenticationKind: AuthenticationType?
    
    var isUserLoggedIn: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }
    
    func loginUserByEmail(email: String, password: String) async throws {
        try await self.authAPIClient.login(email: email, password: password)
        self.authenticationKind = .email
    }
    
    func loginUsingGoogle(from vc: UIViewController) async throws {
        let socialInfo = try await socialManager.fetchSocialNetworkInfo(forSocialType: .google, fromVC: vc)
        let credential = GoogleAuthProvider.credential(withIDToken: socialInfo.idToken, accessToken: socialInfo.accesToken)
        try await authAPIClient.login(with: credential)
        self.authenticationKind = .google
    }
    
    func registerUser(displayName: String, email: String, password: String) async throws {
        try await authAPIClient.registerUser(email: email, password: password)
        self.authenticationKind = .email
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        try await changeRequest?.commitChanges()
    }
    
    func recoverPasword(email: String) async throws {
        try await authAPIClient.recoverPassword(email: email)
    }
    
    func isUsernameNotUsed(username: String) async throws -> Bool {
        return false
    }
}
