//
//  Created by Marc Hidalgo on 15/5/23.
//

import FirebaseFirestore

public extension DocumentReference {
    func fetchDocument<T: Decodable>() async throws -> T {
        let documentSnapshot = try await self.getDocument()
        return try documentSnapshot.data(as: T.self)
    }
}

public extension Query {
    func fetchAllDocuments<T: Decodable>() async throws -> [T] {
        let querySnapshot = try await self.getDocuments()
        return querySnapshot.documents.compactMap { (queryDocumentSnapshot) -> T? in
            return try? queryDocumentSnapshot.data(as: T.self)
        }
    }
    
    func fetchPaged<T: Decodable>(startAfter: QueryDocumentSnapshot? = nil, pageSize: Int = PicsiteAPI.PagingConfiguration.PageSize) async throws -> PagedResult<T> {
        let query = startAfter != nil ? self.start(afterDocument: startAfter!) : self
        let querySnapshot = try await query.limit(to: pageSize).getDocuments()
        
        guard let lastDocument = querySnapshot.documents.last else {
            return PagedResult(items: [], morePageAvailable: false, lastDocument: nil)
        }
        
        let nextQuerySnapshot = try await self.start(afterDocument: lastDocument).limit(to: 1).getDocuments()
        let morePageAvailable = nextQuerySnapshot.documents.count > 0
        
        let items = querySnapshot.documents.compactMap { queryDocumentSnapshot -> T? in
            try? queryDocumentSnapshot.data(as: T.self)
        }
        
        return PagedResult(items: items, morePageAvailable: morePageAvailable, lastDocument: lastDocument)
    }
}
