 //
//  Created by Marc Hidalgo on 9/11/22.
//

import MapKit

public class AnnotationMarkerView: MKMarkerAnnotationView {
    public override var annotation: MKAnnotation? {
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
