//
//  Created by Marc Hidalgo on 13/5/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct PhotoDocument: Codable {
    public init(_photoURLString: String, _thumbnailPhotoURLString: String, createdAt: Date, userCreatedID: String) {
        self._photoURLString = _photoURLString
        self._thumbnailPhotoURLString = _thumbnailPhotoURLString
        self.createdAt = createdAt
        self.userCreatedID = userCreatedID
    }
    
    @DocumentID private var _id: String?
    private let _photoURLString: String
    private let _thumbnailPhotoURLString: String
    public let createdAt: Date
    public let userCreatedID: String

    public var id: String {
        guard let _id else { fatalError() }
        return _id
    }
    
    public var photoURL: URL? {
        return URL(string: _photoURLString)
    }
    
    public var thumbnailPhotoURL: URL? {
        return URL(string: _thumbnailPhotoURLString)
    }
    
    enum CodingKeys: String, CodingKey {
        case _id
        case _photoURLString = "image_url"
        case _thumbnailPhotoURLString = "thumbnail_image_url"
        case createdAt = "created_at"
        case userCreatedID = "user_created_id"
    }
}
