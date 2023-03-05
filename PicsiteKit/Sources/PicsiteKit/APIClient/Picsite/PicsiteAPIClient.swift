 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseFirestore
import FirebaseAuth

public class PicsiteAPIClient {
    
    let environment: PicsiteAPI.Environment
    let firestore = Firestore.firestore()
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
    }
    
    public func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    public func login(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
    public func registerUser(email: String, password: String) async throws -> String {
        return try await Auth.auth().createUser(withEmail: email, password: password).user.uid
    }
    
    public func recoverPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public func createUser(_ user: User) async throws {
        guard let userID = user.id else { throw LogicError.InvalidUser }
        try await firestore.collection(RootFirestoreCollection.users.rawValue).document(userID).setData(from: user)
    }
    
    public func isUsernameCurrentlyUsed(username: String) async throws -> Bool {
        let usernameQuery = try await firestore.collection(RootFirestoreCollection.users.rawValue).whereField(FirestoreField.username.rawValue, isEqualTo: username).getDocuments()
        return !usernameQuery.isEmpty
    }
    
    public func fetchAnnotations() async throws -> [Picsite] {
        let querySnapshot = try await firestore.collection(RootFirestoreCollection.picsites.rawValue).getDocuments()
        return querySnapshot.documents.compactMap { (queryDocumentSnapshot) -> Picsite? in
            return try? queryDocumentSnapshot.data(as: Picsite.self)
        }
    }
}

private extension FirebaseFirestore.DocumentReference {
    func setData<T: Encodable>(from: T, merge: Bool = false) async throws {
        let encoder = Firestore.Encoder()
        let data = try encoder.encode(from)
        try await setData(data, merge: merge)
    }
}
