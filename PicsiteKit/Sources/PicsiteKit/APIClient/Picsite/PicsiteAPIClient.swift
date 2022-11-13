 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseFirestore
import FirebaseAuth

public class PicsiteAPIClient {
    
    let environment: PicsiteAPI.Environment
    
//    open var userID: String?
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
    }
    
    public func createUser(docData: [String: Any]) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { throw LogicError.InvalidState }
        let db = Firestore.firestore()
        try await db.collection(RootFirestoreCollection.users.rawValue).document(userId).setData(docData)
    }
    
    public func isUsernameCurrentlyUsed(username: String) async throws -> Bool {
        let db = Firestore.firestore()
        let usernameQuery = try await db.collection(RootFirestoreCollection.users.rawValue).whereField(FirestoreField.username.rawValue, isEqualTo: username).getDocuments()
        return !usernameQuery.isEmpty
    }
}

public extension PicsiteAPIClient {
    enum LogicError: Int, Swift.Error {
        case InvalidState = -1
    }
}

public extension PicsiteAPIClient {
    
    enum RootFirestoreCollection: String {
        case users = "users"
    }
    
    enum FirestoreField: String {
        case username = "username"
    }
    
}
