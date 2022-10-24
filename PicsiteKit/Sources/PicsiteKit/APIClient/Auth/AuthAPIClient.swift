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
    
    public func login(with credential: AuthCredential) async throws -> User {
       return try await Auth.auth().signIn(with: credential).user
    }
    
    public func recoverPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public enum AuthError: LocalizedError {
        case unknownError
        case invalidLoginPassword
        case userAlreadyExists
        case weakPassword

        public var errorDescription: String? {
            switch self {
            case .userAlreadyExists:
                return "User already exists. Did you forget your password?"
            case .invalidLoginPassword:
                return "Invalid email or password"
            case .weakPassword:
                return "Your password needs to have at least 8 characters with:\n- At least 1 lower case letter\n- At least 1 upper case letter\n- At least 1 numeric character\n- At least 1 special character"
            default:
                return "Unknown Error"
            }
        }
    }
}
