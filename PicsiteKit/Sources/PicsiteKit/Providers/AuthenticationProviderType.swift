//
//  AuthenticationProviderType.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation

public protocol AuthenticationProviderType: AnyObject {
    
    func loginUser(email: String, password: String) async throws
    
}
