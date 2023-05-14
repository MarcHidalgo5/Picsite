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
    
    func uploadImageToFirebaseStorage(data: Data, at path: String) async throws -> URL {
        try await self.apiClient.uploadImageToFirebaseStorage(data: data, at: path)
    }
}
