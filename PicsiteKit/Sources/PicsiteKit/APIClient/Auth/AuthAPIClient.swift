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
    
    public func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    public func login(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
    public func registerUser(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    public func createUser(docData: [String: Any]) async throws {
//        Firebase
//        let db = Firestore.firestore()
//        db.collection("data").document("two").setData(docData) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
    }
    
    public func recoverPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
