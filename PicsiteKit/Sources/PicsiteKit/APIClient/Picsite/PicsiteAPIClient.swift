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
    
    let pageSize = PicsiteAPI.PagingConfiguration.PageSize
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
    }
    
    //Auth
    
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
        try await firestore.collection(FirestoreRootCollections.users.rawValue).document(userID).setData(user)
    }
    
    public func isUsernameCurrentlyUsed(username: String) async throws -> Bool {
        let usernameQuery = try await firestore.collection(FirestoreRootCollections.users.rawValue).whereField(FirestoreFields.username.rawValue, isEqualTo: username).getDocuments()
        return !usernameQuery.isEmpty
    }
    
    //Map
    
    public func fetchAnnotations() async throws -> [Picsite] {
        let querySnapshot = try await firestore.collection(FirestoreRootCollections.picsites.rawValue).getDocuments()
        return querySnapshot.documents.compactMap { (queryDocumentSnapshot) -> Picsite? in
            return try? queryDocumentSnapshot.data(as: Picsite.self)
        }
    }
    
    //Picsite Profile
    
    public func fetchPicsiteProfile(picsiteID: String) async throws -> Picsite {
        let querySnapshot = try await firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID).getDocument()
        guard let picsite = try querySnapshot.data(as: Picsite.self) else { throw  PicsiteAPIError.userNotFound }
        return picsite
    }
    
    public func fetchPhotoURLs(for picsiteID: String, startAfter: QueryDocumentSnapshot? = nil) async throws -> PhotoURLsResult {
        let baseQuery = firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID).collection(FirestoreCollections.photos.rawValue).limit(to: pageSize)
        let query = startAfter != nil ? baseQuery.start(afterDocument: startAfter!) : baseQuery
        let querySnapshot = try await query.getDocuments()
        guard let lastDocument = querySnapshot.documents.last else {
            return .init(photos: [], morePageAvaliable: false, lastDocument: nil)
        }
        let nextQuerySnapshot = try await baseQuery.start(afterDocument: lastDocument).limit(to: 1).getDocuments()
        let morePageAvaliable = nextQuerySnapshot.documents.count > 0
        let photos = querySnapshot.documents.compactMap { queryDocumentSnapshot -> PhotoURLsResult.PhotoDocument? in
            try? queryDocumentSnapshot.data(as: PhotoURLsResult.PhotoDocument.self)
        }
        return .init(photos: photos, morePageAvaliable: morePageAvaliable, lastDocument: lastDocument)
    }
}

enum PicsiteAPIError: Swift.Error {
    case userNotFound
}

private extension FirebaseFirestore.DocumentReference {
    func setData<T: Encodable>(_ from: T, merge: Bool = false) async throws {
        let encoder = Firestore.Encoder()
        let data = try encoder.encode(from)
        try await setData(data, merge: merge)
    }
}
