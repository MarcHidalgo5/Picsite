//
//  Created by Marc Hidalgo on 8/11/22.
//

import MapKit
import PicsiteKit

public class PicsiteAnnotation_: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public let title: String?
    public let subtitle: String?
    public let picsiteData: Picsite
    
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, picsiteData: Picsite) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.picsiteData = picsiteData
    }
}

extension PicsiteAnnotation_ {
    var icon: UIImage {
        switch picsiteData.type {
        case .landscape:
            return UIImage(systemName: "binoculars.fill")!
        case .none:
            return UIImage(systemName: "empty")!
        }
    }
}

public class PicsiteAnnotation: NSObject, MKAnnotation {
    public let id: String
    public let title: String?
    public let subtitle: String?
    public let annotationType: AnnotationType
    public let lastActivity: Activity?
    public var coordinate: CLLocationCoordinate2D
    public let photoCount: Int
    public let location: String?
    public let profilePhotoID: String?
    
    public enum AnnotationType {
        case landscape
    }
    
    public enum Activity {
        case recentlyUsed
        case lastWeekUsed
        case lastTwoWeeks
        case lastThreeWeeks
        case lastMonthUsed
        case moreThanAMonth
    }
    
    public init(id: String, title: String? = nil, subtitle: String? = nil, annotationType: PicsiteAnnotation.AnnotationType, lastActivity: PicsiteAnnotation.Activity, coordinate: CLLocationCoordinate2D, photoCount: Int, location: String, profilePhotoID: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.annotationType = annotationType
        self.lastActivity = lastActivity
        self.coordinate = coordinate
        self.photoCount = photoCount
        self.location = location
        self.profilePhotoID = profilePhotoID
    }
}

public extension PicsiteAnnotation {
    var markerTintColor: UIColor {
        switch lastActivity {
        case .recentlyUsed, .lastWeekUsed:
            return .green
        case .lastTwoWeeks, .lastThreeWeeks, .lastMonthUsed:
            return .yellow
        case .moreThanAMonth:
            return .red
        case .none:
            return .white
        }
    }
    
    var icon: UIImage {
        switch annotationType {
        case .landscape:
            return UIImage(systemName: "binoculars.fill")!
        }
    }
}
