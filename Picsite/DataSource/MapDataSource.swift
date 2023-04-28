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
        return .init(annotations: try await annotations.picsiteAnnotations())
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
                thumbnailURL: thumnailURL(stringURL: $0.thumbnailURLString),
                lastActivityDateString: dateFormatterString(date: $0.lastActivity)
            )
        })
    }
    
    func dateFormatterString(date: Date?) -> String {
        guard let lastActivity = date else { return "" }
        return PicsiteDateDecodingStrategy.string(from: lastActivity)
    }
    
    func thumnailURL(stringURL: String?) -> URL? {
        guard let thumbnailURLString = stringURL else { return nil }
        return URL(string: thumbnailURLString)
    }
}

private extension Date {
    func days(toDate: Date?) -> Int? {
        guard let toDate = toDate else { return nil }
        return Calendar.current.dateComponents([.day], from: self, to: toDate).day
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
