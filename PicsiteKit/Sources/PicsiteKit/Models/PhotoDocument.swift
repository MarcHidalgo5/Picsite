//
//  Created by Marc Hidalgo on 13/5/23.
//

import Foundation
import FirebaseFirestoreSwift

public struct PhotoDocument: Codable {
    @DocumentID private var ID: String?
    public let photoURLString: String
    public let thumbnailPhotoURLString: String
    
    public var id: String {
        guard let ID else { fatalError() }
        return ID
    }
    
    enum CodingKeys: String, CodingKey {
        case ID
        case photoURLString = "image_url"
        case thumbnailPhotoURLString = "thumbnail_image_url"
    }
}
