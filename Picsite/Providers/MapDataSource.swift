//
//  Created by Marc Hidalgo on 8/11/22.
//

import Foundation
import PicsiteMapKit
import CoreLocation
import PicsiteKit

class MapDataSource: MapDataSourceType {
    func fetchAnnotations() async throws -> MapViewController.VM {
        let startAnnotation = Annotation(
            title: "start",
            subtitle: nil,
            annotationType: .landscape,
            activity: .frequentlyUsed,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.61803,
                longitude: 0.62772
            )
        )
        
        let secondAnnotation = Annotation(
            title: "second",
            subtitle: nil,
            annotationType: .landscape,
            activity: .normallyUsed,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.62803,
                longitude: 0.63772
            )
        )
        
        let lastAnnotation = Annotation(
            title: "last",
            subtitle: nil,
            annotationType: .landscape,
            activity: .underutilized,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.60803,
                longitude: 0.61772
            )
        )
        let annotations = [startAnnotation, secondAnnotation, lastAnnotation]
        return .init(annotations: annotations)
    }
}
