//
//  Created by Marc Hidalgo on 14/5/23.
//

import Foundation
import FirebaseFirestore

public struct PagedResult<T: Decodable> {
    public var items: [T]
    public var morePageAvailable: Bool
    public var lastDocument: QueryDocumentSnapshot?
}
