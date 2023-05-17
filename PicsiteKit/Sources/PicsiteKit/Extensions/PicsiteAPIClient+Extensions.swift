//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation
import FirebaseFirestore

public extension PicsiteAPIClient {
    enum LogicError: Int, Swift.Error {
        case InvalidState = -1
        case InvalidUser = -2
    }
}

public extension PicsiteAPIClient {
    
    public enum FirestoreRootCollections: String {
        case users = "users"
        case picsites = "picsites"
    }
    
    public enum FirestoreCollections: String {
        case photos = "photos"
        case profilePhotos = "profile_Photos"
    }
    
    public enum FirestoreFields: String {
        case username = "username"
        case createdAt = "created_at"
    }
}
