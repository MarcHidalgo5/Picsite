 //
//  Created by Marc Hidalgo on 9/11/22.
//

import MapKit

class AnnotationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let picsiteAnnotation = newValue as? PicsiteAnnotation else {
                return
            }
            markerTintColor = picsiteAnnotation.markerTintColor
            glyphImage = picsiteAnnotation.icon
            glyphTintColor = .black
            animatesWhenAdded = true
            canShowCallout = false
        }
    }
}
