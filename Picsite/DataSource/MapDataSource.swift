//
//  Created by Marc Hidalgo on 8/11/22.
//

import PicsiteKit; import PicsiteUI
import UIKit
import BSWInterfaceKit
import PicisteProfileKit
import PicsiteMapKit

class MapDataSource: MapDataSourceType {
    
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchAnnotations() async throws -> MapViewController.VM {
        let annotations = try await apiClient.fetchAnnotations()
        return .init(annotations: try await annotations.picsiteAnnotations())
    }
    
    func picsiteProfileViewController(picsiteID: String) -> UIViewController {
        return PicsiteProfileViewController(picsiteID: picsiteID)
    }
}

private extension Array where Element == Picsite {
    func picsiteAnnotations() async throws -> [PicsiteAnnotation] {
        self.map({
            let days = Date().days(toDate: $0.lastActivity)
            let activity = $0.activityForInterval(days)
            return .init(
                coordinate: .init(
                    latitude: $0.coordinate.latitude,
                    longitude: $0.coordinate.longitude),
                title: $0.title,
                subtitle: activity.title,
                activity: activity,
                picsiteData: $0,
                thumbnailPhoto: Photo.createWithDeepBlueColor(withURL: nil),
                imageURL: $0.imageURLString?.toURL,
                lastActivityDateString: $0.lastActivity.dateFormatterString
            )
        })
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
