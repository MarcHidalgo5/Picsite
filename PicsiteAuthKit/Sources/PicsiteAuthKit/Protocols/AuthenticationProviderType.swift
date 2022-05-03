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
    
    func loginUser(email: String, password: String) async throws -> User
    func loginUsingGoogle(with credential: AuthCredential) async throws
    
}
