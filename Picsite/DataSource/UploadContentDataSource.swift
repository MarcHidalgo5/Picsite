//
//  Created by Marc Hidalgo on 15/5/23.
//

import Foundation
import PicsiteUploadContentKit
import PicsiteKit

class UploadContentDataSource: UploadContentDataSourceType {
    
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func uploadImageToFirebaseStorage(with localImageURL: URL) async throws -> URL {
        let data = try Data(contentsOf: localImageURL)
        let path = "\(PicsiteAPIClient.FirestoreRootCollections.picsites)/fileName.jpeg"
        return try await self.apiClient.uploadImageToFirebaseStorage(data: data, at: path)
    }
}
