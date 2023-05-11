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

class AuthenticationDataSource: AuthenticationDataSourceType {
        
    private let authStorage = AuthStorage.defaultStorage
    private let apiClient: PicsiteAPIClient
    private let socialManager: AuthenticationManagerSocialType
    
    init(apiClient: PicsiteAPIClient, environment: PicsiteAPI.Environment) {
        self.socialManager = SocialNetworkManager.shared
        self.apiClient = apiClient
    }
    
    @CodableUserDefaultsBacked(key: "authentication-kind", defaultValue: nil)
    var authenticationKind: AuthenticationType?
    
    var isUserLoggedIn: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }
    
    func loginUserByEmail(email: String, password: String) async throws {
        try await self.apiClient.login(email: email, password: password)
        self.authenticationKind = .email
    }
    
    func loginUsingGoogle(from vc: UIViewController) async throws {
        let socialInfo = try await socialManager.fetchSocialNetworkInfo(forSocialType: .google, fromVC: vc)
        let credential = GoogleAuthProvider.credential(withIDToken: socialInfo.idToken, accessToken: socialInfo.accesToken)
        try await apiClient.login(with: credential)
        self.authenticationKind = .google
    }
    
    func registerUser(username: String, fullName: String, email: String, password: String) async throws {
        if try await self.apiClient.isUsernameCurrentlyUsed(username: username) {
            throw AuthenticationPerformerError.usenameUnavaliable
        }
        let userID = try await apiClient.registerUser(email: email, password: password)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        try await changeRequest?.commitChanges()
        let user = User(id: userID, username: username, fullName: fullName)
        try await apiClient.createUser(user)
        self.authenticationKind = .email
    }
    
    func recoverPasword(email: String) async throws {
        try await apiClient.recoverPassword(email: email)
    }
}
