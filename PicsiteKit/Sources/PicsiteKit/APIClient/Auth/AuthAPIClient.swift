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
    
    public let authEnvironment: Environment
    
    public init(authEnvironment: Environment = .production) {
        self.authEnvironment = authEnvironment
    }
    
    public func login(email: String, password: String) async throws -> User {
        return try await Auth.auth().signIn(withEmail: email, password: password).user
    }
    
    public enum Environment: BSWFoundation.Environment {
        case development
        case production

        public var baseURL: URL {
            switch self {
            case .development:
                fatalError()
            case .production:
                fatalError()
            }
        }
    }
    
}
