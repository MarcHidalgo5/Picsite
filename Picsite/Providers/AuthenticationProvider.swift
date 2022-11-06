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
    
    func registerUser(username: String, fullName: String, email: String, password: String) async throws {
        if try await self.apiClient.isUsernameCurrentlyUsed(username: username) {
            throw AuthenticationPerformerError.usenameUnavaliable
        }
        try await authAPIClient.registerUser(email: email, password: password)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        try await changeRequest?.commitChanges()
        try await apiClient.createUser(docData: docData(username: username, fullName: fullName))
        self.authenticationKind = .email
    }
    
    func recoverPasword(email: String) async throws {
        try await authAPIClient.recoverPassword(email: email)
    }
}

#warning("Create endpoint correctly")
extension AuthenticationProvider {
    func docData(username: String, fullName: String) -> [String: Any] {
        return [
            "username": username,
            "full_name": fullName
        ]
    }
}
