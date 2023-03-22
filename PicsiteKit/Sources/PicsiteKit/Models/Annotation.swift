//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit
import FirebaseFirestore

public struct Picsite: Codable {
    @DocumentID private var ID: String?
    public let title: String
    public let coordinate: GeoPoint
    public let type: AnnotationType
    public let lastActivity: Date?
    public let photoCount: Int
        //    public let location: String?
    public let profilePhotoID: String?
    public var id: String {
        get {
            guard let ID else { fatalError() }
            return ID
        }
    }

    enum CodingKeys: String, CodingKey {
        case lastActivity = "last_activity", photoCount = "photo_count", profilePhotoID = "profile_photo_ID", title, coordinate, type, ID
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

//    public enum Activity {
//        case recentlyUsed
//        case lastWeekUsed
//        case lastTwoWeeks
//        case lastThreeWeeks
//        case lastMonthUsed
//        case moreThanAMonth
//    }