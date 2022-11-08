 //
//  Created by Marc Hidalgo on 8/11/22.
//

import MapKit

public class PicsiteAnnotation: NSObject, MKAnnotation {
    public let title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    
    public init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
