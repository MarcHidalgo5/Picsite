//
//  AuthAPIClient.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation

public class AuthAPIClient {
    
    public let authEnvironment: Environment
    
    public init(authEnvironment: Environment = .production) {
        self.authEnvironment = authEnvironment
    }
    
    func login(user: String, password: String) {
        
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
