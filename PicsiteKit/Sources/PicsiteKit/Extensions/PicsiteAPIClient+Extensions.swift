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
    
    enum RootFirestoreCollection: String {
        case users = "users"
    }
    
    enum FirestoreField: String {
        case username = "username"
    }
    
}
