//
//  Created by Marc Hidalgo on 13/5/23.
//

import Foundation
import FirebaseFirestore

public class PagingInfo {
    public var nextPage: QueryDocumentSnapshot?
    public var morePagesAreAvailable: Bool
    public var lastDocument: QueryDocumentSnapshot?
    
    public init(nextPage: QueryDocumentSnapshot? = nil, morePagesAreAvailable: Bool = false, lastDocument: QueryDocumentSnapshot? = nil) {
        self.nextPage = nextPage
        self.morePagesAreAvailable = morePagesAreAvailable
        self.lastDocument = lastDocument
    }
}
