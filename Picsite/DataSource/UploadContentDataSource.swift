//
//  Created by Marc Hidalgo on 15/5/23.
//

import Foundation
import PicsiteUploadContentKit
import PicsiteMapKit
import PicsiteKit; import PicsiteUI
import CoreLocation
//import GeoFire

class UploadContentDataSource: UploadContentDataSourceType {
   
    let apiClient: PicsiteAPIClient
    let mapDataSource: MapDataSourceType
    
    private var currentPicsites: [Picsite] = []
    
    init(apiClient: PicsiteAPIClient, mapDataSource: MapDataSourceType) {
        self.apiClient = apiClient
        self.mapDataSource = mapDataSource
    }
    
    func uploadImageToFirebaseStorage(with localImageURL: URL, into picsiteID: Picsite.ID) async throws {
        return try await self.apiClient.uploadImage(into: picsiteID, localImageURL: localImageURL)
    }

    func getClosestPicsite(to location: CLLocation?) async throws -> Picsite? {
        guard let location else { return nil }
        self.currentPicsites = try await mapDataSource.fetchAnnotations().picsites()
        return currentPicsites.closest(to: location, withinRadius: 500)
    }
    
    func fetchAnnotations() async throws -> BaseMapViewController.VM {
        if self.currentPicsites.isEmpty == false {
            return .init(annotations: currentPicsites.picsiteAnnotations())
        } else {
            return try await mapDataSource.fetchAnnotations()
        }
    }
}

extension BaseMapViewController.VM {
    func picsites() -> [Picsite] {
        self.annotations.map({ $0.picsiteData })
    }
}
extension Array where Element == Picsite {
    func closest(to location: CLLocation, withinRadius radius: Double) -> Picsite? {
        var closestPicsite: Picsite?
        var smallestDistance: CLLocationDistance = radius
        
        let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        for picsite in self {
            let picsiteLocation = CLLocation(latitude: picsite.coordinate.latitude, longitude: picsite.coordinate.longitude)
            let distance = currentLocation.distance(from: picsiteLocation)
            
            if distance <= smallestDistance {
                smallestDistance = distance
                closestPicsite = picsite
            }
        }
        
        return closestPicsite
    }
}
