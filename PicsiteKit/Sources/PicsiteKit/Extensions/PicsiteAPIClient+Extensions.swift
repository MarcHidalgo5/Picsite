//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation
import FirebaseFirestore

public extension PicsiteAPIClient {
    
    func fetchDocument<T: Decodable>(documentRef: DocumentReference) async throws -> T {
        let documentSnapshot = try await documentRef.getDocument()
        guard let document = try documentSnapshot.data(as: T.self) else {
            throw PicsiteAPIError.documentNotFound
        }
        return document
    }
    
    func fetchAllDocuments<T: Decodable>(query: Query) async throws -> [T] {
        let querySnapshot = try await query.getDocuments()
        return querySnapshot.documents.compactMap { (queryDocumentSnapshot) -> T? in
            return try? queryDocumentSnapshot.data(as: T.self)
        }
    }
    
    func fetchPaged<T: Decodable>(baseQuery: Query, startAfter: QueryDocumentSnapshot? = nil) async throws -> PagedResult<T> {
        let query = startAfter != nil ? baseQuery.start(afterDocument: startAfter!) : baseQuery
        let querySnapshot = try await query.limit(to: self.pageSize).getDocuments()
        
        guard let lastDocument = querySnapshot.documents.last else {
            return PagedResult(items: [], morePageAvailable: false, lastDocument: nil)
        }
        
        let nextQuerySnapshot = try await baseQuery.start(afterDocument: lastDocument).limit(to: 1).getDocuments()
        let morePageAvailable = nextQuerySnapshot.documents.count > 0
        
        let items = querySnapshot.documents.compactMap { queryDocumentSnapshot -> T? in
            try? queryDocumentSnapshot.data(as: T.self)
        }
        
        return PagedResult(items: items, morePageAvailable: morePageAvailable, lastDocument: lastDocument)
    }
}

public extension PicsiteAPIClient {
    enum LogicError: Int, Swift.Error {
        case InvalidState = -1
        case InvalidUser = -2
    }
}

public extension PicsiteAPIClient {
    
    enum FirestoreRootCollections: String {
        case users = "users"
        case picsites = "picsites"
    }
    
    enum FirestoreCollections: String {
        case photos = "photos"
        case profilePhotos = "profile_Photos"
    }
    
    enum FirestoreFields: String {
        case username = "username"
        case createdAt = "created_at"
    }
}
