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

class AuthenticationProvider: AuthenticationProviderType {
    
    private let authAPIClient: AuthAPIClient
    private let socialManager: AuthenticationManagerSocialManagerType
    
    init(environment: PicsiteAPI.Environment) {
        self.authAPIClient = AuthAPIClient(authEnvironment: environment)
        self.socialManager = SocialNetworkManager.shared
    }
    
    var isUserLoggedIn: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }
    
    func loginUserByEmail(email: String, password: String) async throws -> User {
        try await self.authAPIClient.login(email: email, password: password)
    }
    
    func loginUsingGoogle(from vc: UIViewController) async throws -> User{
        let socialInfo = try await socialManager.fetchSocialNetworkInfo(forSocialType: .google, fromVC: vc)
        let credential = GoogleAuthProvider.credential(withIDToken: socialInfo.idToken, accessToken: socialInfo.accesToken)
       return try await authAPIClient.login(with: credential)
        
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
