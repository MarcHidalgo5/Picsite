//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation

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
    
    enum FirestoreCollections {
        
    }
    
    enum FirestoreFields: String {
        case username = "username"
    }
}
