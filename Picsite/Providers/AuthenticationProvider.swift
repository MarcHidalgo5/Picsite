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

class AuthenticationProvider: AuthenticationProviderType {
    
    private let authAPIClient: AuthAPIClient
    
    init(environment: PicsiteAPI.Environment) {
        self.authAPIClient = AuthAPIClient.init(authEnvironment: environment)
    }
    
    func loginUser(email: String, password: String) async throws -> User {
        try await self.authAPIClient.login(email: email, password: password)
    }
}
