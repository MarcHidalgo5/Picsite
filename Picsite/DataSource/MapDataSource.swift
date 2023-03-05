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
        let annotations = try await apiClient.fetchAnnotations()
        return .init(annotations: annotations.picsiteAnnotations())
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

private extension Array where Element == Picsite {
    func picsiteAnnotations() -> [PicsiteAnnotation] {
        self.map({
            let interval = Date() - ($0.lastActivity ?? Date())
            let activity = $0.activityForInterval(interval.day)
            return .init(
                coordinate: .init(
                    latitude: $0.coordinate.latitude,
                    longitude: $0.coordinate.longitude),
                title: $0.title,
                subtitle: activity.title,
                activity: activity,
                picsiteData: $0
            )
        })
    }
}

private extension Date {
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

private extension Picsite {
    func activityForInterval(_ interval: Int?) -> PicsiteAnnotation.Activity {
        guard let interval else { return .neverUsed }
        switch interval {
        case 0..<7:
            return .recentlyUsed
        case 7..<14:
            return .lastWeekUsed
        case 14..<21:
            return .lastTwoWeeks
        case 21..<28:
            return .lastThreeWeeks
        case 28..<31:
            return .lastMonthUsed
        default:
            return .moreThanAMonth
        }
    }
}
