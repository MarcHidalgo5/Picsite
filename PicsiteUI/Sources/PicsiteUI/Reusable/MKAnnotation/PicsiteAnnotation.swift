//
//  Created by Marc Hidalgo on 8/11/22.
//

import MapKit
import BSWInterfaceKit
import PicsiteKit

public class PicsiteAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public let title: String?
    public let subtitle: String?
    public let activity: Activity
    public let picsiteData: Picsite
    public let thumbnailPhoto: Photo
    public let imageURL: URL?
    public let lastActivityDateString: String
    
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, activity: Activity, picsiteData: Picsite, thumbnailPhoto: Photo, imageURL: URL? = nil, lastActivityDateString: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.activity = activity
        self.picsiteData = picsiteData
        self.thumbnailPhoto = thumbnailPhoto
        self.imageURL = imageURL
        self.lastActivityDateString = lastActivityDateString
    }
    
    public enum Activity {
        case recentlyUsed
        case lastWeekUsed
        case lastTwoWeeks
        case lastThreeWeeks
        case lastMonthUsed
        case moreThanAMonth
        case neverUsed
        
        public var title: String {
            switch self {
            case .recentlyUsed:
                return "map-recently-used-subtitle".localized
            case .lastWeekUsed:
                return "map-last-week-used-subtitle".localized
            case .lastTwoWeeks:
                return "map-last-two-week-used-subtitle".localized
            case .lastThreeWeeks:
                return "map-last-three-week-used-subtitle".localized
            case .lastMonthUsed:
                return "map-last-month-used-subtitle".localized
            case .moreThanAMonth:
                return "map-more-than-one-month-used-subtitle".localized
            case .neverUsed:
                return "map-never-used-subtitle".localized
            }
        }
    }
}

public extension PicsiteAnnotation {
    var markerTintColor: UIColor {
        switch activity {
        case .recentlyUsed, .lastWeekUsed:
            return .green
        case .lastTwoWeeks, .lastThreeWeeks, .lastMonthUsed:
            return .yellow
        case .moreThanAMonth:
            return .red
        case .neverUsed:
            return .white
        }
    }
    
    var icon: UIImage {
        switch picsiteData.type {
        case .landscape:
            return UIImage(systemName: "binoculars.fill")!
        case .none:
            return UIImage(systemName: "empty")!
        }
    }
}
