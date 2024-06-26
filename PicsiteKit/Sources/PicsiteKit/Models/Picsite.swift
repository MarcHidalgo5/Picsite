//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit
import FirebaseFirestore

public struct Picsite: Codable, Identifiable {
    public init(title: String, coordinate: GeoPoint, type: Picsite.AnnotationType = .landscape, lastActivity: Date? = nil, photoCount: Int = 0, _thumbnailURLString: String? = nil, _imageURLString: String? = nil, location: String, createdAt: Date = Date()) {
        self.title = title
        self.coordinate = coordinate
        self.type = type
        self.lastActivity = lastActivity
        self.photoCount = photoCount
        self._thumbnailURLString = _thumbnailURLString
        self._imageURLString = _imageURLString
        self.location = location
        self.createdAt = createdAt
    }
    
    @DocumentID private var _id: String?
    public let title: String
    public let coordinate: GeoPoint
    public let type: AnnotationType
    public let lastActivity: Date?
    public let photoCount: Int
    private let _thumbnailURLString: String?
    private let _imageURLString: String?
    public let location: String
    public let createdAt: Date
    
    public var id: String {
        guard let _id else { fatalError() }
        return _id
    }
    
    public var thumbnailURL: URL? {
        guard let _thumbnailURLString = _thumbnailURLString else { return nil }
        return URL(string: _thumbnailURLString)
    }
    
    public var imageURL: URL? {
        guard let _imageURLString = _imageURLString else { return nil }
        return URL(string: _imageURLString)
    }

    enum CodingKeys: String, CodingKey {
        case lastActivity = "last_activity", location, photoCount = "photo_count", _imageURLString = "image_url" , _thumbnailURLString = "thumbnail_image_url", title, coordinate, type, _id, createdAt = "created_at"
    }
    
    public enum AnnotationType: Codable, Hashable {
        case landscape
        case none
        
        public init(from decoder: Decoder) throws {
            do {
                let stringValue = try decoder.singleValueContainer().decode(String.self)
                switch stringValue {
                case "landscape":
                    self = .landscape
                default:
                    self = .none
                }
            } catch {
                self = .none
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .landscape:
                try container.encode("landscape")
            case .none:
                try container.encodeNil()
            }
        }
    }
}
