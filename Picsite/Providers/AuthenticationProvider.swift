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

class AuthenticationProvider: AuthenticationProviderType {
    
    private let authAPIClient: AuthAPIClient
    
    init(environment: PicsiteAPI.Environment) {
        self.authAPIClient = AuthAPIClient(authEnvironment: environment)
    }
    
    func loginUser(email: String, password: String) async throws -> User {
        try await self.authAPIClient.login(email: email, password: password)
    }
    
    func loginUsingGoogle(with credential: AuthCredential) async throws {
        _ = try await authAPIClient.login(with: credential)
        
    }
    
//    enum Error: Swift.Error, LocalizedError {
//        case invalidAPIResponse
//        case noResponseForThisContact
//
//        public var errorDescription: String? {
//            switch self {
//            case .invalidAPIResponse:
//                return "Invalid response"
//            case .noResponseForThisContact:
//                return "The answer you're looking for has been deleted"
//            }
//        }
//    }
}
