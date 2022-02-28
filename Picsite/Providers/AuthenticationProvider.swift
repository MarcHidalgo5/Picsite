//
//  AuthenticationProvider.swift
//  Picsite
//
//  Created by Marc Hidalgo on 28/2/22.
//

import PicsiteKit
import BSWFoundation
import Foundation

class AuthenticationProvider: AuthenticationProviderType {
    
    private let authAPIClient: AuthAPIClient
    
    init() {
        self.authAPIClient = AuthAPIClient.init()
    }
    
    func loginUser(email: String, password: String) async throws {
        
    }
}
