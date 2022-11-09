 //
//  Created by Marc Hidalgo on 8/11/22.
//

import MapKit

public class PicsiteAnnotation: NSObject, MKAnnotation {
    public let title: String?
    public var subtitle: String?
    public let annotationType: AnnotationType
    public let activity: Activity
    public var coordinate: CLLocationCoordinate2D
    
    public enum AnnotationType {
        case landscape
    }
    
    public enum Activity {
        case frequentlyUsed
        case normallyUsed
        case underutilized
    }
    
    public init(title: String? = nil, subtitle: String? = nil, annotationType: AnnotationType, activity: Activity, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.annotationType = annotationType
        self.activity = activity
        self.coordinate = coordinate
    }
}

extension PicsiteAnnotation {
    var markerTintColor: UIColor {
        switch activity {
        case .frequentlyUsed:
            return UIColor.green
        case .normallyUsed:
            return UIColor.yellow
        case .underutilized:
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
