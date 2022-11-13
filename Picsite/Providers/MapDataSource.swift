//
//  Created by Marc Hidalgo on 8/11/22.
//

import Foundation
import PicsiteMapKit
import CoreLocation
import PicsiteKit
import UIKit
import BSWInterfaceKit

class MapDataSource: MapDataSourceType {
    
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchAnnotations() async throws -> MapViewController.VM {
        let startActivity: PicsiteAnnotation.Activity = .recentlyUsed
        let startAnnotation = PicsiteAnnotation(
            id: "b6yYgKDLqw1Yj1HB3vH1",
            title: "La seu vella",
            subtitle: activityLabelFor(lastActivity: startActivity),
            annotationType: .landscape,
            lastActivity: startActivity,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.61803,
                longitude: 0.62772
            ),
            photoCount: 32,
            location: "Lleida, Lleida",
            profilePhotoID: "ZFyDUHNxkH3oyV9eAzN2"
        )
        
        let secondActivity: PicsiteAnnotation.Activity = .lastTwoWeeks
        let secondAnnotation = PicsiteAnnotation(
            id: "test",
            title: "Test large title in annotation",
            subtitle: activityLabelFor(lastActivity: secondActivity),
            annotationType: .landscape,
            lastActivity: secondActivity,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.62803,
                longitude: 0.63772
            ),
            photoCount: 32,
            location: "Lleida, Lleida",
            profilePhotoID: "ZFyDUHNxkH3oyV9eAzN2"
        )
        
        let lastActivity: PicsiteAnnotation.Activity = .moreThanAMonth
        let lastAnnotation = PicsiteAnnotation(
            id: "test",
            title: "Pis xenia",
            subtitle: activityLabelFor(lastActivity: lastActivity),
            annotationType: .landscape,
            lastActivity: lastActivity,
            coordinate: CLLocationCoordinate2D(
                latitude: 41.60803,
                longitude: 0.61772
            ),
            photoCount: 32,
            location: "Lleida, Lleida",
            profilePhotoID: "ZFyDUHNxkH3oyV9eAzN2"
        )
        let annotations = [startAnnotation, secondAnnotation, lastAnnotation]
        return .init(annotations: annotations)
    }
    
    func fetchDetailAFor(annotation: PicsiteAnnotation) async throws -> AnnotationCalloutView.VM {
//        if let profilePhotoID = annotation.profilePhotoID {
//
//        } else {
//
//        }
//        let path = "picsites/\(annotation.id)/profile_photos/\(annotation.profilePhotoID)/profile_photo_thumbnail.jpeg"
//        let reference = Storage.storage().reference(withPath: path)
//
//        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
//                if let err = error {
//                   print(err)
//              } else {
//                if let image  = data {
//                     let myImage: UIImage! = UIImage(data: image)
//
//                     // Use Image
//                }
//             }
//        }
        return .init(annotation: annotation, photo: Photo(kind: .empty))
    }
}

private extension MapDataSource {
    func activityLabelFor(lastActivity: PicsiteAnnotation.Activity) -> String {
        switch lastActivity {
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
        }
    }
}
