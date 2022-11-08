//
//  Created by Marc Hidalgo on 8/11/22.
//

import Foundation
import PicsiteMapKit
import CoreLocation

class MapDataSource: MapDataSourceType {
    func fetchAnnotations() async throws -> MapViewController.VM {
        let startAnnotation = PicsiteAnnotation(
            title: "start",
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.61803,
                longitude: 0.62772
            )
        )
        
        let secondAnnotation = PicsiteAnnotation(
            title: "second",
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.62803,
                longitude: 0.63772
            )
        )
        
        let lastAnnotation = PicsiteAnnotation(
            title: "last",
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.60803,
                longitude: 0.61772
            )
        )
        let annotations = [startAnnotation, secondAnnotation, lastAnnotation]
        return .init(annotations: annotations)
    }
}
