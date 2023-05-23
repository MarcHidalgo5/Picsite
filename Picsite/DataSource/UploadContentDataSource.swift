//
//  Created by Marc Hidalgo on 15/5/23.
//

import Foundation
import PicsiteUploadContentKit
import PicsiteKit
import CoreLocation
//import GeoFire

class UploadContentDataSource: UploadContentDataSourceType {
 
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func uploadImageToFirebaseStorage(with localImageURL: URL, into picsiteID: Picsite.ID) async throws {
        return try await self.apiClient.uploadImage(into: picsiteID, localImageURL: localImageURL)
    }
    
    func getPicsite(for location: CLLocation) -> Picsite {
        return try await self.apiClient.getPicsite(for: location)
    }
}
