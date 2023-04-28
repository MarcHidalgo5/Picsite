//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift

public struct User: Codable {
    @DocumentID var id: String?
    public let username: String?
    public let fullName: String?
    
    public init(id: String?, username: String?, fullName: String?) {
        self.id = id
        self.username = username
        self.fullName = fullName
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case fullName
    }
}
