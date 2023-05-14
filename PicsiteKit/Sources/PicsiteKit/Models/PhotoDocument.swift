//
//  Created by Marc Hidalgo on 13/5/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct PhotoURLsResult {
    public let photos: [PhotoDocument]
    public let morePageAvaliable: Bool
    public let lastDocument: QueryDocumentSnapshot?
    
    public struct PhotoDocument: Codable {
        @DocumentID private var _id: String?
        private let _photoURLString: String
        private let _thumbnailPhotoURLString: String

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
        }
        
    }
}




