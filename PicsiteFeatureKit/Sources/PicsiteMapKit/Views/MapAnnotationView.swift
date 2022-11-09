 //
//  Created by Marc Hidalgo on 9/11/22.
//

import MapKit
import PicsiteKit

class AnnotationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let picsiteAnnotation = newValue as? Annotation else {
                return
            }
            markerTintColor = picsiteAnnotation.markerTintColor
            glyphImage = picsiteAnnotation.icon
            animatesWhenAdded = true
        }
    }
}
