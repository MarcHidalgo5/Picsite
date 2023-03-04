 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseFirestore
import FirebaseAuth

public class PicsiteAPIClient {
    
    let environment: PicsiteAPI.Environment
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
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
    
    public func recoverPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public func createUser(docData: [String: Any]) async throws {
        guard let userID = Auth.auth().currentUser?.uid else { throw LogicError.InvalidUser }
        let db = Firestore.firestore()
        try await db.collection(RootFirestoreCollection.users.rawValue).document(userID).setData(docData)
    }
    
    public func isUsernameCurrentlyUsed(username: String) async throws -> Bool {
        let db = Firestore.firestore()
        let usernameQuery = try await db.collection(RootFirestoreCollection.users.rawValue).whereField(FirestoreField.username.rawValue, isEqualTo: username).getDocuments()
        return !usernameQuery.isEmpty
    }
}
