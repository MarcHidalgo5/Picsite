//
//  AuthAPIClient.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseAuth

public class AuthAPIClient {
    
    public let authEnvironment: PicsiteAPI.Environment
    
    public init(authEnvironment: PicsiteAPI.Environment) {
        self.authEnvironment = authEnvironment
    }
    
    public func login(email: String, password: String) async throws -> User {
        return try await Auth.auth().signIn(withEmail: email, password: password).user
    }
}
