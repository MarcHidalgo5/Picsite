 //
//  Created by Marc Hidalgo on 8/11/22.
//

import MapKit

public class PicsiteAnnotation: NSObject, MKAnnotation {
    public let id: String
    public let title: String?
    public let subtitle: String?
    public let annotationType: AnnotationType
    public let lastActivity: Activity
    public var coordinate: CLLocationCoordinate2D
    public let photoCount: Int
    public let location: String
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
            return UIColor.green
        case .lastTwoWeeks, .lastThreeWeeks, .lastMonthUsed:
            return UIColor.yellow
        case .moreThanAMonth:
            return UIColor.red
        }
    }
    
    var icon: UIImage {
        switch annotationType {
        case .landscape:
            return UIImage(systemName: "binoculars.fill")!
        }
    }
}
